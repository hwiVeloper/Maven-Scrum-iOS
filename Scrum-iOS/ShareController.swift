//
//  ShareController.swift
//  Scrum-iOS
//
//  Created by Jonghwi Lee on 2017. 6. 22..
//  Copyright © 2017년 Jonghwi Lee. All rights reserved.
//

import Foundation
import UIKit
import ActionSheetPicker_3_0

class ShareController : UITableViewController {
    @IBOutlet var selectedSeqLabel: UILabel!
    @IBOutlet var btnSelectSeq: UIButton!
    
    var selectSeq : Int = 4
    
    lazy var sList : [ShareVO] = {
        var datalist = [ShareVO]()
        
        return datalist
    } ()

    
    override func viewWillAppear(_ animated: Bool) {
        //
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.selectedSeqLabel.text = "\(self.selectSeq) 회"
    }
    
    override func viewDidLoad() {
        callShareAPI(seq: self.selectSeq)
    }
    
    @IBAction func seqPicker(_ sender: UIButton) {
        let acp = ActionSheetMultipleStringPicker(title: "회차선택", rows: [
                ["1", "2", "3", "4"],
                ["회"]
            ], initialSelection: [3, 0], doneBlock: { // 마지막 회차로 고정
                picker, values, indexes in
                
                self.selectedSeqLabel.text = "\((indexes as! NSArray)[0]) 회"
                self.selectSeq = ((indexes as! NSArray)[0] as! NSString).integerValue
                
                self.callShareAPI(seq: self.selectSeq)
                self.tableView.reloadData()
                
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        
        acp?.show()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.sList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "shareList", for: indexPath) as! ShareCell
        
        cell.userName.text = row.userName
        cell.forumTitle.text = "[\(row.forumType!)] \(row.forumTitle!)"
        
        return cell

    }
    
    func callShareAPI(seq: Int) {
        self.sList.removeAll()
        
        let url = "http://api.mismaven.kr/forum/seq/\(self.selectSeq)"
        let apiURI : URL! = URL(string: url)
        let apidata = try! Data(contentsOf: apiURI)
        
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            let suggestions = apiDictionary["result"] as! NSArray
            
            for row in suggestions {
                let r = row as! NSDictionary
                
                let svo = ShareVO()
                
                svo.forumTitle = r["forum_title"] as? String
                svo.userName = r["user_name"] as? String
                svo.forumType = r["forum_type"] as? String
                svo.forumWriter = r["forum_writer"] as? String
                svo.forumYm = r["forum_ym"] as? String
                svo.forumSeq = (r["forum_seq"] as? NSString)?.integerValue
                svo.forumContent = r["forum_content"] as? String
                
                // list 배열에 추가
                self.sList.append(svo)
            }
        } catch {
            NSLog("Parse Error!")
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail" {
            //셀 정보 확인
            let cell = sender as! ShareCell
            
            // 행 정보를 이용하여 몇 번 째 행을 클릭했는지 확인
            let path = self.tableView.indexPath(for: cell)
            
            // 행 정보를 가져온다.
            let shareInfo = self.sList[path!.row]
            
            // 선택된 글을 찾은 후 dest 뷰 컨트롤러의 svo 변수로 대입
            let detailVC = segue.destination as? ShareDetailController
            
            // 플랜 정보를 detailVC쪽 svo에 값을 담는다.
            detailVC?.sdvo = shareInfo
        }
    }
}

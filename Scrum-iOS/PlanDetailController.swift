//
//  PlanDetailController.swift
//  Scrum-iOS
//
//  Created by Jonghwi Lee on 2017. 6. 19..
//  Copyright © 2017년 Jonghwi Lee. All rights reserved.
//

import Foundation
import UIKit
import FontAwesomeKit

class PlanDetailController : UITableViewController {
    @IBOutlet var userName: UILabel!
    @IBOutlet var planComment: UITextView!
    @IBOutlet var userImg: UIImageView!
    
    @IBOutlet var btnReply: UIBarButtonItem!
    @IBOutlet var commentTitle: UILabel!
    
    // 목록에서 넘어온 플랜 정보 변수
    var pvo : PlanVO!
    
    lazy var list : [PlanDetailVO] = {
        var datalist = [PlanDetailVO]()
        
        return datalist
    } ()
    
    override func viewDidLoad() {
        // set basic information
        self.navigationItem.title = self.pvo?.planDate
        self.userName.text = self.pvo?.userName
        self.planComment.text = self.pvo?.planComment
        self.userImg.image = self.pvo?.userImgView
        self.userImg.layer.cornerRadius = self.userImg.frame.width/2.0
        self.userImg.clipsToBounds = true

        
        self.btnReply.title = "댓글 \(self.pvo?.replyCount ?? 0)"
        
        callDetailAPI()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pRow = self.list[indexPath.row]
        let pCell = tableView.dequeueReusableCell(withIdentifier: "planList") as! PlanDetailCell
        
        // FAK check / uncheck icons
        let checkIcon = FAKFontAwesome.checkIcon(withSize: 20)
        checkIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.00, green:0.53, blue:0.00, alpha:1.0))
        let checkIconImage = checkIcon?.image(with: CGSize(width: 20, height: 20))
        
        let uncheckIcon = FAKFontAwesome.timesIcon(withSize: 20)
        uncheckIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.87, green:0.00, blue:0.00, alpha:1.0))
        let uncheckIconImage = uncheckIcon?.image(with: CGSize(width: 20, height: 20))

        
        pCell.planContent?.text = pRow.planContent
        if pRow.planStatus == "1"{
            pCell.planStatus?.image = checkIconImage
        } else if pRow.planStatus == "0" {
            pCell.planStatus?.image = uncheckIconImage
        } else {
            pCell.planStatus?.image = nil
        }
        
        return pCell
    }
    
    func callDetailAPI() {
        let url = "http://api.mismaven.kr/plan/detail/date/\(self.pvo.planDate!)/user/\(self.pvo.userId!)"
        let apiURI : URL! = URL(string: url)
        let apidata = try! Data(contentsOf: apiURI)
        
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            // 데이터 구조에 따라 차례대로 캐스팅하여 읽어온다.
            let details = apiDictionary["details"] as! NSArray
            
            for row in details {
                let r = row as! NSDictionary
                
                let pdvo = PlanDetailVO()
                
                pdvo.planDetailSeq = (r["plan_detail_seq"] as! NSString).integerValue
                pdvo.planContent = r["plan_content"] as? String
                pdvo.planStatus = r["plan_status"] as? String
                
                self.list.append(pdvo)
            }
        } catch {
            NSLog("Parse Error!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "replySegue" {
            // 일정 정보를 가져온다
            let planInfo = self.pvo
            
            let replyVC = segue.destination as? ReplyController
            
            replyVC?.pvo = planInfo
        }
    }
}

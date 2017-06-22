//
//  ReplyController.swift
//  Scrum-iOS
//
//  Created by Jonghwi Lee on 2017. 6. 21..
//  Copyright © 2017년 Jonghwi Lee. All rights reserved.
//

import Foundation
import UIKit

class ReplyController : UITableViewController {
    @IBOutlet var nothingView: UIView!
    
    // 목록에서 넘어온 플랜 정보 변수
    var pvo : PlanVO!
    
    lazy var replyList : [ReplyVO] = {
        var datalist = [ReplyVO]()

        return datalist
    } ()
    
    override func viewDidLoad() {
        callReplyAPI()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.replyList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rRow = self.replyList[indexPath.row]
        let rCell = tableView.dequeueReusableCell(withIdentifier: "replyList") as! ReplyCell
        
        rCell.replyUser.text = rRow.userName
        
        rCell.replyContent.text = rRow.replyComment
        rCell.replyContent.sizeToFit()
        
        // get image of reply user
        DispatchQueue.main.async(execute: {
            rCell.replyUserImg.image = self.getThumbnailImage(indexPath.row)
            rCell.replyUserImg.layer.cornerRadius = rCell.replyUserImg.frame.width/2.0
            rCell.replyUserImg.clipsToBounds = true
        })
        return rCell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            print("DELETE•ACTION");
        });
        
        return [deleteRowAction];
    }
    
    func callReplyAPI() {
        self.replyList.removeAll()
        
        let url = "http://api.mismaven.kr/reply/date/\(self.pvo.planDate!)/user/\(self.pvo.userId!)"
        let apiURI : URL! = URL(string: url)
        let apidata = try! Data(contentsOf: apiURI)
        
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            // 데이터 구조에 따라 차례대로 캐스팅하여 읽어온다.
            let replies = apiDictionary["result"] as! NSArray
            
            self.navigationItem.title = "댓글(\(apiDictionary["count"] ?? 0))"
            
            for row in replies {
                let r = row as! NSDictionary

                let rvo = ReplyVO()

                rvo.replyLevel = (r["reply_level"] as! NSString).integerValue
                rvo.replyId = r["reply_id"] as? String
                rvo.userId = r["user_id"] as? String
                rvo.writeUser = r["write_user"] as? String
                rvo.planDate = r["plan_date"] as? String
                rvo.replyComment = r["reply_comment"] as? String
                rvo.replyTimestamp = r["reply_timestamp"] as? String
                rvo.upReplyId = r["up_reply_id"] as? String
                rvo.upReplyUser = r["up_reply_user"] as? String
                rvo.userName = r["user_name"] as? String
                rvo.userImg = r["user_img"] as? String

                // =====> 추가 코드 : 웹상 이미지를 읽어와서 저장
                let url: URL! = URL(string: rvo.userImg!)
                let imageData = try! Data(contentsOf: url)
                pvo.userImgView = UIImage(data: imageData)
                // <===== 이미지 읽기 끝
                
                // list 배열에 추가
                self.replyList.append(rvo)
            }
            
            let rCount = (apiDictionary["count"] as? NSString)!.integerValue
            if rCount == 0 {
                self.nothingView.isHidden = false
            } else {
                self.nothingView.isHidden = true
            }
        } catch {
            NSLog("Parse Error!")
        }
    }
    
    func getThumbnailImage(_ index : Int) -> UIImage {
        // 인자값으로 받은 인덱스를 기반으로 해당하는 배열 데이터를 읽어온다.
        let rvo = self.replyList[index]
        
        // 메모이제이션 : 저장된 이미지가 있으면 반환, 없으면 다운로드 후 반환
        if let savedImage = rvo.userImgView {
            return savedImage
        } else {
            let url: URL! = URL(string: rvo.userImg!)
            let imageData = try! Data(contentsOf: url)
            rvo.userImgView = UIImage(data: imageData) // UIImage를 MovieVO 객체에 우선 저장
            
            return rvo.userImgView!
        }
    }
}

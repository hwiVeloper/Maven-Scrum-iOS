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
    
    // 목록에서 넘어온 플랜 정보 변수
    var pvo : PlanVO!
    
    lazy var replyList : [ReplyVO] = {
        var datalist = [ReplyVO]()

        return datalist
    } ()
    
    override func viewDidLoad() {
        //
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.replyList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rRow = self.replyList[indexPath.row]
        let rCell = tableView.dequeueReusableCell(withIdentifier: "replyList") as! ReplyCell
        
        rCell.replyUser.text = rRow.
        
        return rCell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            print("DELETE•ACTION");
        });
        
        return [deleteRowAction];
    }
    
    func callReplyAPI() {
        
    }
}

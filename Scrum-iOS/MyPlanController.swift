//
//  MyPlanController.swift
//  Scrum-iOS
//
//  Created by Jonghwi Lee on 2017. 6. 21..
//  Copyright © 2017년 Jonghwi Lee. All rights reserved.
//

import Foundation
import UIKit

class MyPlanController : UITableViewController {
    @IBOutlet var planDate: UILabel!
    
    let formatter = DateFormatter()
    let sessionUser = UserDefaults.standard.string(forKey: "sessionId")
    
    lazy var list : [PlanDetailVO] = {
        return [PlanDetailVO]()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        let date = Date()
        self.formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: date)
        self.planDate.text = today
        
        callPlanListAPI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //
    }
    
    override func viewDidLoad() {
        //
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "planList") as! MyPlanCell
        
        cell.planContent.text = row.planContent
        cell.planStatus.isOn = (row.planStatus! as NSString).boolValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            print("DELETE•ACTION");
        });

        return [deleteRowAction];
    }
    
    func callPlanListAPI() {
        self.list.removeAll()
        
        // API 호출을 위한 URI 생성
        let url = "http://api.mismaven.kr/plan/my/date/\(self.planDate.text!)/user/\(self.sessionUser!)"
        let apiURI : URL! = URL(string: url)
        
        // API 호출
        let apidata = try! Data(contentsOf: apiURI)
        
        // JSON 객체를 파싱하여 NSDictionary 객체로 받는다.
        do {
            let apiDic = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary

            let plans = apiDic["result"] as! NSArray
            
            for row in plans {
                // 순회 상수를 NSDictionary 타입으로 캐스팅
                let r = row as! NSDictionary
                
                // 테이블 뷰 리스트를 구성할 방식
                let pvo = PlanDetailVO()
                // plan 각 배열에 데이터를 pvo에 할당
                pvo.planDetailSeq = (r["plan_detail_seq"] as? NSString)?.integerValue
                pvo.planContent = r["plan_content"] as? String
                pvo.planStatus = r["plan_status"] as? String
                
                self.list.append(pvo)
            }
            
            // 전체 데이터에 대한 카운트
            let totalCount = (apiDic["count"] as! NSNumber).intValue
            
            if totalCount == 0 {
                
            } else {
                
            }
        } catch {
            NSLog("Parse Error!")
        }
    }
}

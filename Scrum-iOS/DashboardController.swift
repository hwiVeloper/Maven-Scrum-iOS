//
//  DashboardController.swift
//  Maven Scrum
//
//  Created by Jonghwi Lee on 2017. 6. 15..
//  Copyright © 2017년 Jonghwi Lee. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import FontAwesomeKit

class DashboardController : UITableViewController {
    @IBOutlet var planDate: UILabel!
    @IBOutlet var nothing: UILabel!
    @IBOutlet var nothingView: UIView!
    
    let formatter = DateFormatter()
    var today: String!
    
    
    // datalist
    lazy var list : [PlanVO] = {
        var datalist = [PlanVO]()
        
        return datalist
    } ()
    
    override func viewDidLoad() {
        // set today date
        let date = Date()
        self.formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: date)
        self.planDate.text = today
        
        callPlanListAPI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        callPlanListAPI()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count // count of rows have to created
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanList") as! PlanCell
        
        cell.userName?.text = row.userName
        cell.planContent1?.text = row.planContent1
        cell.planContent2?.text = row.planContent2
        cell.planContent3?.text = row.planContent3
        cell.planCreationDttm?.text = row.planCreationDttm
        cell.replyCount?.text = "\(row.replyCount ?? 0)"
        
        let reply = FAKFontAwesome.commentingOIcon(withSize: 20)
        let replyIconImage = reply?.image(with: CGSize(width: 30, height: 30))
        // set fontawesome icon
        cell.replyIcon.image = replyIconImage
        
        let checkIcon = FAKFontAwesome.checkIcon(withSize: 20)
        checkIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.00, green:0.53, blue:0.00, alpha:1.0))
        let checkIconImage = checkIcon?.image(with: CGSize(width: 20, height: 20))
        
        let uncheckIcon = FAKFontAwesome.timesIcon(withSize: 20)
        uncheckIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.87, green:0.00, blue:0.00, alpha:1.0))
        let uncheckIconImage = uncheckIcon?.image(with: CGSize(width: 20, height: 20))
        
        // set fontawesome icon
        cell.planStatus1?.image = row.planStatus1 == "1" ? checkIconImage : row.planStatus1 == "0" ? uncheckIconImage : nil
        cell.planStatus2?.image = row.planStatus2 == "1" ? checkIconImage : row.planStatus2 == "0" ? uncheckIconImage : nil
        cell.planStatus3?.image = row.planStatus3 == "1" ? checkIconImage : row.planStatus3 == "0" ? uncheckIconImage : nil
        
        DispatchQueue.main.async(execute: {
            cell.userImg.image = self.getThumbnailImage(indexPath.row)
            cell.userImg.layer.cornerRadius = cell.userImg.frame.width/2.0
            cell.userImg.clipsToBounds = true
        })
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }

    @IBAction func dateSelect(_ sender: Any) {
        
        let asp = ActionSheetDatePicker(title: "Date:", datePickerMode: UIDatePickerMode.date, selectedDate: NSDate() as Date, doneBlock: {
            picker, value, index in
            self.planDate.text = self.formatter.string(from: value as! Date)
            print("date editted")
            self.callPlanListAPI()
            
            self.tableView.reloadData()
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender as! UIView)
        
        asp?.show()

    }
    
    func datePicked(obj: NSDate) {
        print("date picked")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func callPlanListAPI() {
        self.list.removeAll()
        
        // API 호출을 위한 URI 생성
        let url = "http://api.mismaven.kr/plan/other/date/\(self.planDate.text!)"
        let apiURI : URL! = URL(string: url)
        
        // API 호출
        let apidata = try! Data(contentsOf: apiURI)
        
        // JSON 객체를 파싱하여 NSDictionary 객체로 받는다.
        do {
            let apiDic = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            // 데이터 구조에 따라 차례대로 캐스팅하여 읽어온다.
            let plans = apiDic["result"] as! NSArray
            
            // Iterator 처리를 하면서 API 데이터를 MovieVO 객체에 저장
            for row in plans {
                // 순회 상수를 NSDictionary 타입으로 캐스팅
                let r = row as! NSDictionary
                
                // 테이블 뷰 리스트를 구성할 방식
                let pvo = PlanVO()
                // plan 각 배열에 데이터를 pvo에 할당
                pvo.userId = r["user_id"] as? String
                pvo.planDate = r["plan_date"] as? String
                pvo.userName = r["user_name"] as? String
                pvo.planCreationDttm = "\(r["plan_creation_dttm"] ?? "")에 작성"
                pvo.userImg = r["user_img"] as? String
                pvo.replyCount = (r["reply_count"] as! NSString).integerValue
                pvo.planContent1 = r["plan_content_1"] as? String
                pvo.planContent2 = r["plan_content_2"] as? String
                pvo.planContent3 = r["plan_content_3"] as? String
                pvo.planStatus1 = r["plan_status_1"] as? String
                pvo.planStatus2 = r["plan_status_2"] as? String
                pvo.planStatus3 = r["plan_status_3"] as? String
                
                // =====> 추가 코드 : 웹상 이미지를 읽어와서 저장
                let url: URL! = URL(string: pvo.userImg!)
                let imageData = try! Data(contentsOf: url)
                pvo.userImgView = UIImage(data: imageData)
                // <===== 이미지 읽기 끝
                
                // list 배열에 추가
                self.list.append(pvo)
            }
            
            // 전체 데이터에 대한 카운트
            let totalCount = (apiDic["count"] as? NSString)!.integerValue
            
            if totalCount == 0 {
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
        let pvo = self.list[index]
        
        // 메모이제이션 : 저장된 이미지가 있으면 반환, 없으면 다운로드 후 반환
        if let savedImage = pvo.userImgView {
            return savedImage
        } else {
            let url: URL! = URL(string: pvo.userImg!)
            let imageData = try! Data(contentsOf: url)
            pvo.userImgView = UIImage(data: imageData) // UIImage를 MovieVO 객체에 우선 저장
            
            return pvo.userImgView!
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail" {
            //셀 정보 확인
            let cell = sender as! PlanCell
            
            // 행 정보를 이용하여 몇 번 째 행을 클릭했는지 확인
            let path = self.tableView.indexPath(for: cell)
            
            // 행 정보를 가져온다.
            let planInfo = self.list[path!.row]
            
            // 선택된 플랜을 찾은 후 dest 뷰 컨트롤러의 mvo 변수로 대입
            let detailVC = segue.destination as? PlanDetailController
            
            // 플랜 정보를 detailVC쪽 pvo에 값을 담는다.
            detailVC?.pvo = planInfo
        }
    }
}

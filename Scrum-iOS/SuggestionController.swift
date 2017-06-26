//
//  SuggestionController.swift
//  Scrum-iOS
//
//  Created by Jonghwi Lee on 2017. 6. 21..
//  Copyright © 2017년 Jonghwi Lee. All rights reserved.
//

import Foundation
import UIKit

class SuggestionController : UITableViewController {
    
    weak var aiv : UIActivityIndicatorView!
    
    var refresher: UIRefreshControl!
    
    lazy var sList : [SuggestionVO] = {
        var datalist = [SuggestionVO]()
        
        return datalist
    } ()
    
    override func viewWillAppear(_ animated: Bool) {
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        tableView.backgroundView = activityIndicatorView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.aiv = activityIndicatorView
        tableView.addSubview(self.aiv)

        
        // 당겨서 새로고침 추가
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        refresher.addTarget(self, action: #selector(SuggestionController.refreshData), for: .valueChanged)
        tableView.addSubview(refresher)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.aiv.startAnimating()
        
        OperationQueue.main.addOperation() {
            self.aiv.stopAnimating()
            self.callSuggestionAPI()
            
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            self.tableView.reloadData()
            
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.sList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionList", for: indexPath) as! SuggestionCell
        
        cell.userName.text = row.userName
        cell.suggestionContent.text = row.suggestionContent
        
        // get image of suggestion user
        DispatchQueue.main.async(execute: {
            cell.userImg.image = self.getThumbnailImage(indexPath.row)
            cell.userImg.layer.cornerRadius = cell.userImg.frame.width/2.0
            cell.userImg.clipsToBounds = true
        })
        
        return cell
    }
    
    func callSuggestionAPI() {
        self.sList.removeAll()
        
        let url = "http://api.mismaven.kr/suggestion"
        let apiURI : URL! = URL(string: url)
        let apidata = try! Data(contentsOf: apiURI)
        
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            let suggestions = apiDictionary["result"] as! NSArray
            
            for row in suggestions {
                let r = row as! NSDictionary
                
                let svo = SuggestionVO()
                
                svo.suggestionId = r["suggestion_id"] as? String
                svo.userId = r["user_id"] as? String
                svo.suggestionContent = r["suggestion_content"] as? String
                svo.suggestionTimestamp = r["suggestion_timestamp"] as? String
                svo.suggestionComplete = r["suggestion_complete"] as? String
                svo.userName = r["user_name"] as? String
                svo.userImg = r["user_img"] as? String
                
                // =====> 추가 코드 : 웹상 이미지를 읽어와서 저장
                let url: URL! = URL(string: svo.userImg!)
                let imageData = try! Data(contentsOf: url)
                svo.userImgView = UIImage(data: imageData)
                // <===== 이미지 읽기 끝
                
                // list 배열에 추가
                self.sList.append(svo)
            }
        } catch {
            NSLog("Parse Error!")
        }
    }
    
    func refreshData() {
        callSuggestionAPI()
        tableView.reloadData()
        refresher.endRefreshing()
    }
    
    func getThumbnailImage(_ index : Int) -> UIImage {
        // 인자값으로 받은 인덱스를 기반으로 해당하는 배열 데이터를 읽어온다.
        let svo = self.sList[index]
        
        // 메모이제이션 : 저장된 이미지가 있으면 반환, 없으면 다운로드 후 반환
        if let savedImage = svo.userImgView {
            return savedImage
        } else {
            let url: URL! = URL(string: svo.userImg!)
            let imageData = try! Data(contentsOf: url)
            svo.userImgView = UIImage(data: imageData) // UIImage를 MovieVO 객체에 우선 저장
            
            return svo.userImgView!
        }
    }

}

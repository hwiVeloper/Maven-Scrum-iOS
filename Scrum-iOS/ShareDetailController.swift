//
//  ShareDetailController.swift
//  Scrum-iOS
//
//  Created by Jonghwi Lee on 2017. 6. 27..
//  Copyright © 2017년 Jonghwi Lee. All rights reserved.
//

import Foundation
import UIKit
import Down

class ShareDetailController : UIViewController {
    var sdvo : ShareVO!
    
    @IBOutlet var markdownView: UIWebView!
    @IBOutlet var btnEdit: UIBarButtonItem!
    @IBOutlet var btnDelete: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        let ud = UserDefaults.standard.string(forKey: "sessionId")
        
        // 세션아이디와 작성자 비교
        if ud != sdvo.forumWriter {
            self.navigationItem.rightBarButtonItems = nil
        }
    }
    
    override func viewDidLoad() {
        let downView = Down(markdownString: sdvo.forumContent!)
        let htmlView = try? downView.toHTML()
        markdownView.loadHTMLString(htmlView!, baseURL: nil)
    }
}

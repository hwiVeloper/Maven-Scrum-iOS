//
//  MainController.swift
//  Scrum-iOS
//
//  Created by Jonghwi Lee on 2017. 6. 15..
//  Copyright © 2017년 Jonghwi Lee. All rights reserved.
//

import Foundation
import UIKit
import ReachabilitySwift

class LoadController : UIViewController {
    @IBOutlet var loadLabel: UILabel!
    @IBOutlet var loadSpinner: UIActivityIndicatorView!
    
    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        self.loadSpinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sleep(2)
        
        // Override point for customization after application launch.
        let reachability = Reachability.init()
        
        if !(reachability?.isReachable)! {
            let alert = UIAlertController(title: "네트워크 연결 확인", message: "네트워크 연결을 확인해 주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in
                CATransaction.setCompletionBlock({
                    exit(0)
                })
            }))
        }
        
        if (self.ud.string(forKey: "sessionId") != nil) {
            self.loadSpinner.stopAnimating()
            NSLog("okay ===== \(self.ud.string(forKey: "sessionId") ?? "")")
            self.performSegue(withIdentifier: "loadMain", sender: nil)
        } else {
            self.loadSpinner.stopAnimating()
            NSLog("no session")
            
            self.performSegue(withIdentifier: "loadLogin", sender: nil)
        }
    }
    
    
}

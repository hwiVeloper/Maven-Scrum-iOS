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
    
    override func viewDidLoad() {
        //
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.selectedSeqLabel.text = "4 회"
    }
    
    @IBAction func seqPicker(_ sender: UIButton) {
        let acp = ActionSheetMultipleStringPicker(title: "회차선택", rows: [
                ["1", "2", "3", "4"],
                ["회"]
            ], initialSelection: [3, 0], doneBlock: { // 마지막 회차로 고정
                picker, values, indexes in
                
                self.selectedSeqLabel.text = "\((indexes as! NSArray)[0]) 회"
                self.selectSeq = (indexes as! NSArray)[0] as! Int
                
                NSLog("\(self.selectSeq)")
                
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        
        acp?.show()
    }
}

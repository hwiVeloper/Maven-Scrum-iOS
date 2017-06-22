//
//  TabBarController.swift
//  Scrum-iOS
//
//  Created by Jonghwi Lee on 2017. 6. 21..
//  Copyright © 2017년 Jonghwi Lee. All rights reserved.
//

import Foundation
import UIKit
import FontAwesomeKit

class TabBarController : UITabBarController {
    override func viewDidLoad() {
        let tabToday = self.tabBar.items![0]
        tabToday.title = "모두의오늘" // tabbar title
        tabToday.image = FAKFontAwesome.calendarIcon(withSize: 25).image(with: CGSize(width: 25, height:25))
        
        let tabPlan = self.tabBar.items![1]
        tabPlan.title = "나의 일정"
        tabPlan.image = FAKFontAwesome.pencilIcon(withSize: 25).image(with: CGSize(width:25, height:25))
        
        let tabSuggestion = self.tabBar.items![2]
        tabSuggestion.title = "건의사항"
        tabSuggestion.image = FAKFontAwesome.inboxIcon(withSize: 25).image(with: CGSize(width:25, height:25))
        
        let tabShare = self.tabBar.items![3]
        tabShare.title = "나눔의장"
        tabShare.image = FAKFontAwesome.shareAltIcon(withSize: 25).image(with: CGSize(width:25, height:25))
        
        let tabMy = self.tabBar.items![4]
        tabMy.title = "마이페이지"
        tabMy.image = FAKFontAwesome.userOIcon(withSize: 25).image(with: CGSize(width:25, height:25))
    }
    
    
    /* Set Tab Bar */
    func setTabbar() -> UITabBarController
    {
        // get storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarcntrl = UITabBarController()
        
        // get each view controllers
        let everybodyToday = storyboard.instantiateViewController(withIdentifier: "everybodyToday")
        let myPlan = storyboard.instantiateViewController(withIdentifier: "myPlan")
        let suggestion = storyboard.instantiateViewController(withIdentifier: "suggestion")
        let myPage = storyboard.instantiateViewController(withIdentifier: "myPage")
        let share = storyboard.instantiateViewController(withIdentifier: "share")
        
        // all viewcontroller embedded navigationbar
        //        let nvToday = UINavigationController(rootViewController: everybodyToday)
        
        // all viewcontroller navigationbar hidden
        //        nvToday.setNavigationBarHidden(true, animated: false)
        
        tabbarcntrl.viewControllers = [everybodyToday, myPlan, suggestion, myPage, share]
        
        let tabbar = tabbarcntrl.tabBar
        //        tabbar.barTintColor = UIColor.black
        //        tabbar.backgroundColor = UIColor.black
        //        tabbar.tintColor = UIColor(red: 43/255, green: 180/255, blue: 0/255, alpha: 1)
        
        //UITabBar.appearance().tintColor = UIColor.white
        //        let attributes = [NSFontAttributeName:UIFont(name: "Montserrat-Light", size: 10)!,NSForegroundColorAttributeName:UIColor.white]
        //        let attributes1 = [NSFontAttributeName:UIFont(name: "Montserrat-Light", size: 10)!,NSForegroundColorAttributeName:UIColor(red: 43/255, green: 180/255, blue: 0/255, alpha: 1)]
        
        //        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        //        UITabBarItem.appearance().setTitleTextAttributes(attributes1, for: .selected)
        
        
        let tabToday = tabbar.items![0]
        tabToday.title = "모두의오늘" // tabbar title
        tabToday.image = FAKFontAwesome.calendarIcon(withSize: 25).image(with: CGSize(width: 25, height:25))
        
        let tabPlan = tabbar.items![1]
        tabPlan.title = "나의 일정"
        tabPlan.image = FAKFontAwesome.pencilIcon(withSize: 25).image(with: CGSize(width:25, height:25))
        
        let tabSuggestion = tabbar.items![2]
        tabSuggestion.title = "건의사항"
        tabSuggestion.image = FAKFontAwesome.inboxIcon(withSize: 25).image(with: CGSize(width:25, height:25))
        
        let tabMy = tabbar.items![3]
        tabMy.title = "마이페이지"
        tabMy.image = FAKFontAwesome.userOIcon(withSize: 25).image(with: CGSize(width:25, height:25))
        
        let tabShare = tabBar.items![4]
        tabShare.title = "나눔의장"
        tabShare.image = FAKFontAwesome.shareAltIcon(withSize: 25).image(with: CGSize(width:25, height:25))
        
        return tabbarcntrl
    }
}

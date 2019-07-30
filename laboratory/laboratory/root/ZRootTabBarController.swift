//
//  ZRootTabBarController.swift
//  laboratory
//
//  Created by hzf on 2019/7/30.
//  Copyright © 2019 zyme. All rights reserved.
//

import UIKit

class ZRootTabBarController: UITabBarController {

    static let rootTabBar = ZRootTabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        self.tabBar.tintColor = UIColor.red
    }
    
    func config(){
        
        let home = ZHomeViewController()
        home.tabBarItem = UITabBarItem(title: "Zyme", image: UIImage(named: "tab_bar_icon_four_normal_33x33_"), selectedImage: UIImage(named: "tab_bar_icon_four_selected_33x33_"))
        
        let live = ZLiveViewController()
         live.tabBarItem = UITabBarItem(title: "Live", image: UIImage(named: "tab_bar_icon_one_normal_33x33_"), selectedImage: UIImage(named: "tab_bar_icon_one_selected_33x33_"))
        
        let work = ZWorkViewController()
        
        work.tabBarItem = UITabBarItem(title: "Work", image: UIImage(named: "tab_bar_icon_article_normal_33x33_"), selectedImage: UIImage(named: "tab_bar_icon_article_selected_33x33_"))
        
        self.addChild(home)
        self.addChild(live)
        self.addChild(work)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

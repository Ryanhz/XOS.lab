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

    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        guard  let index = tabBar.items?.firstIndex(of: item) else {
            return;
        }
        
        
        
    }
//    
//    func tabBarButtons() -> [UITabBarButton] {
//        
//        self.tabBar.subviews.flatMap { (subView) -> Sequence in
//            
//        }
//        
//    }
//    
    
    
    
    
    func createPath(name: String) -> [String]{
        return  (0...36).map { (index) -> String in
            return "\(name)\(index)_33x33_"
        }
    }
}

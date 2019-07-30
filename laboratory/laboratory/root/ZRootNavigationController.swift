//
//  ZRootNavigationController.swift
//  laboratory
//
//  Created by hzf on 2019/7/30.
//  Copyright © 2019 zyme. All rights reserved.
//

import UIKit

class ZRootNavigationController: ZBaseNavigationController {

    static let rootNavigation = ZRootNavigationController(rootViewController: ZRootTabBarController.rootTabBar)
    
    private override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(true, animated: false)
        
    }

}

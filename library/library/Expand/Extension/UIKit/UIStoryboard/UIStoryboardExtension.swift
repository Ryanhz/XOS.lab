//
//  UIStoryboardExtension.swift
//  library
//
//  Created by hzy on 2018/5/14.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func instantiateInitialViewController (storyboardName: MyEnum.StoryboardName, bundle: String? = nil) ->UIViewController?{
        return UIStoryboard(name: storyboardName.rawValue, bundle: nil).instantiateInitialViewController()
    }
}

extension HzyNamespaceWrapper where T: UIStoryboard {
   static func instantiateInitialViewController (storyboardName: MyEnum.StoryboardName, bundle: String? = nil) ->UIViewController?{
        return UIStoryboard(name: storyboardName.rawValue, bundle: nil).instantiateInitialViewController()
    }
}

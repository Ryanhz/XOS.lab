//
//  UIStoryboardExtension.swift
//  zyme
//
//  Created by zyme on 2018/5/14.
//  Copyright © 2018年 zyme. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func instantiateInitialViewController (storyboardName: String, bundle: String? = nil) ->UIViewController?{
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()
    }
}

public extension ZymeNamespaceWrapper where T: UIStoryboard {
   static func instantiateInitialViewController (storyboardName: String, bundle: String? = nil) ->UIViewController?{
        return  UIStoryboard.instantiateInitialViewController(storyboardName: storyboardName, bundle: bundle)
    }
}

//
//  UIViewController+FEExtension.swift
//  Hzy
//
//  Created by hzf on 2017/5/11.
//  Copyright © 2017年 Hzy. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func initFromNib()->Self {
        let hasNib = Bundle.main.path(forResource: self.nameOfClass, ofType: "nib") != nil
        guard hasNib else {
            assert(!hasNib, "Invalid parameter")
            return self.init()
        }
        return self.init(nibName: self.nameOfClass, bundle: nil)
    }
    
    class func initFromStoryBorad(storyboardName: MyEnum.StoryboardName, identifier: String? = nil) ->Self{
        return initFromStoryBorad(storyboardName: storyboardName, identifier: identifier, type: self)
    }
    
    private class func initFromStoryBorad<T>(storyboardName: MyEnum.StoryboardName, identifier: String? = nil, type: T.Type) ->T {
        let sb = UIStoryboard.init(name: storyboardName.rawValue, bundle: nil)
        var vc: UIViewController!
        
        if let identifier = identifier {
            vc =  sb.instantiateViewController(withIdentifier: identifier)
        } else {
            vc =  sb.instantiateViewController(withIdentifier: nameOfClass)
        }
        return vc as! T
    }
}



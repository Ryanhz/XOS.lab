//
//  UIView+Xib.swift
//  Zyme
//
//  Created by hzf on 2017/6/6.
//  Copyright © 2017年 Zyme. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNib(_ name: String? = nil)->Self {
        var className: String = self.nameOfClass
        if let name = name {
            className = name
        }
        return loadFromNibNamed(className, type: self)
    }
    
   private class func loadFromNibNamed<T>(_ name: String, type: T.Type) ->T {
        let xib = Bundle.main.loadNibNamed(name, owner: T.self, options: nil)?[0]
    
        guard let view = xib as? T else {
//            assert(false,  "Invalid parameter")
            return xib as! T
        }
        return view
    }
}


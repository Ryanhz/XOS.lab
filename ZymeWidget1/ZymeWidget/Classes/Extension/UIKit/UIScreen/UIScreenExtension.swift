//
//  UIScreenExtension.swift
//  zyme
//
//  Created by zyme on 2017/11/1.
//  Copyright © 2017年 zyme. All rights reserved.
//

import UIKit

//extension UIScreen: ZymeNamespaceWrappable {}

public extension UIScreen {
    
    class var size: CGSize {
        return UIScreen.main.bounds.size
    }
    
    class var minWidth: CGFloat {
        return min(self.size.width, self.size.height)
    }
    
    class var maxHeight: CGFloat {
        return max(self.size.width, self.size.height)
    }
    
    class var width: CGFloat {
        return min(self.size.width, self.size.height)
    }
    
    class var height: CGFloat {
        return max(self.size.width, self.size.height)
    }
    
    class var mainScale: CGFloat {
        return UIScreen.main.scale
    }
    
    class var mainbounds: CGRect {
        return UIScreen.main.bounds
    }
}

public extension ZymeNamespaceWrapper where T: UIScreen {
    
    static var size: CGSize { return UIScreen.main.bounds.size }
    
    static var width: CGFloat { return self.size.width }
    
    static var height: CGFloat { return self.size.height }
    
    static var scale: CGFloat { return UIScreen.main.scale }
    
    static var bounds: CGRect { return UIScreen.main.bounds }
    
    static var extraBottom: CGFloat { return UIDevice.isScreenElongation ? 34 : 0 }
}



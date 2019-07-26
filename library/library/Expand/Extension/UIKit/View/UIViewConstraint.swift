//
//  UIViewExtension.swift
//  FETools
//
//  Created by hzf on 2017/11/1.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit

//extension UIView: HzyNamespaceWrappable {}
extension HzyNamespaceWrapper where T: UIView {
    /// viewOrigin
    var viewOrigin : CGPoint {
        
        get { return wrappedValue.frame.origin}
        
        set(newVal) {
            
            var tmpFrame         = wrappedValue.frame
            tmpFrame.origin      = newVal
            wrappedValue.frame   = tmpFrame
        }
    }
    
    /// viewSize
    var viewSize : CGSize {
        
        get{ return wrappedValue.frame.size}
        
        set(newVal) {
            
            var tmpFrame        = wrappedValue.frame
            tmpFrame.size       = newVal
            wrappedValue.frame  = tmpFrame
        }
    }
    
    /// x
    var x : CGFloat {
        
        get { return wrappedValue.frame.origin.x}
        
        set(newVal) {
            
            var tmpFrame        = wrappedValue.frame
            tmpFrame.origin.x   = newVal
            wrappedValue.frame  = tmpFrame
        }
    }
    
    /// y
    var y : CGFloat {
        
        get { return wrappedValue.frame.origin.y}
        
        set(newVal) {
            
            var tmpFrame        = wrappedValue.frame
            tmpFrame.origin.y   = newVal
            wrappedValue.frame  = tmpFrame
        }
    }
    
    /// height
    var height : CGFloat {
        
        get { return wrappedValue.frame.size.height}
        
        set(newVal) {
            
            var tmpFrame            = wrappedValue.frame
            tmpFrame.size.height    = newVal
            wrappedValue.frame      = tmpFrame
        }
    }
    
    /// width
    var width : CGFloat {
        
        get { return wrappedValue.frame.size.width}
        
        set(newVal) {
            
            var tmpFrame           = wrappedValue.frame
            tmpFrame.size.width    = newVal
            wrappedValue.frame     = tmpFrame
        }
    }
    
    /// left
    var left : CGFloat {
        
        get { return wrappedValue.frame.origin.x}
        
        set(newVal) {
            
            var tmpFrame        = wrappedValue.frame
            tmpFrame.origin.x   = newVal
            wrappedValue.frame  = tmpFrame
        }
    }
    
    /// right
    var right : CGFloat {
        
        get { return wrappedValue.frame.origin.x + wrappedValue.frame.size.width}
        
        set(newVal) {
            
            var tmpFrame        = wrappedValue.frame
            tmpFrame.origin.x   = newVal - wrappedValue.frame.size.width
            wrappedValue.frame  = tmpFrame
        }
    }
    
    /// top
    var top : CGFloat {
        
        get { return wrappedValue.frame.origin.y}
        
        set(newVal) {
            
            var tmpFrame        = wrappedValue.frame
            tmpFrame.origin.y   = newVal
            wrappedValue.frame  = tmpFrame
        }
    }
    
    /// bottom
    var bottom : CGFloat {
        
        get { return wrappedValue.frame.origin.y + wrappedValue.frame.size.height}
        
        set(newVal) {
            
            var tmpFrame        = wrappedValue.frame
            tmpFrame.origin.y   = newVal - wrappedValue.frame.size.height
            wrappedValue.frame  = tmpFrame
        }
    }
    
    /// centerX
    var centerX : CGFloat {
        
        get { return wrappedValue.center.x}
        set(newVal) { wrappedValue.center = CGPoint(x: newVal, y: wrappedValue.center.y)}
    }
    
    /// centerY
    var centerY : CGFloat {
        
        get { return wrappedValue.center.y}
        set(newVal) { wrappedValue.center = CGPoint(x: wrappedValue.center.x, y: newVal)}
    }
    
    /// middleX
    var middleX : CGFloat {
        
        get { return wrappedValue.bounds.width / 2}
    }
    
    /// middleY
    var middleY : CGFloat {
        
        get { return wrappedValue.bounds.height / 2}
    }
    
    /// middlePoint
    var middlePoint : CGPoint {
        get { return CGPoint(x: wrappedValue.bounds.width / 2, y: wrappedValue.bounds.height / 2)}
    }
    
    
    
    
    
}

// MARK: ---<##>extension UIView
extension UIView {
    
    /// viewOrigin
    var viewOrigin : CGPoint {
        
        get { return frame.origin}
        
        set(newVal) {
            
            var tmpFrame    = frame
            tmpFrame.origin = newVal
            frame           = tmpFrame
        }
    }
    
    /// viewSize
    var viewSize : CGSize {
        
        get{ return frame.size}
        
        set(newVal) {
            
            var tmpFrame  = frame
            tmpFrame.size = newVal
            frame         = tmpFrame
        }
    }
    
    /// x
    var x : CGFloat {
        
        get { return frame.origin.x}
        
        set(newVal) {
            
            var tmpFrame      = frame
            tmpFrame.origin.x = newVal
            frame             = tmpFrame
        }
    }
    
    /// y
    var y : CGFloat {
        
        get { return frame.origin.y}
        
        set(newVal) {
            
            var tmpFrame      = frame
            tmpFrame.origin.y = newVal
            frame             = tmpFrame
        }
    }
    
    /// height
    var height : CGFloat {
        
        get { return frame.size.height}
        
        set(newVal) {
            
            var tmpFrame         = frame
            tmpFrame.size.height = newVal
            frame                = tmpFrame
        }
    }
    
    /// width
    var width : CGFloat {
        
        get { return frame.size.width}
        
        set(newVal) {
            
            var tmpFrame        = frame
            tmpFrame.size.width = newVal
            frame               = tmpFrame
        }
    }
    
    /// left
    var left : CGFloat {
        
        get { return frame.origin.x}
        
        set(newVal) {
            
            var tmpFrame      = frame
            tmpFrame.origin.x = newVal
            frame             = tmpFrame
        }
    }
    
    /// right
    var right : CGFloat {
        
        get { return frame.origin.x + frame.size.width}
        
        set(newVal) {
            
            var tmpFrame      = frame
            tmpFrame.origin.x = newVal - frame.size.width
            frame             = tmpFrame
        }
    }
    
    /// top
    var top : CGFloat {
        
        get { return frame.origin.y}
        
        set(newVal) {
            
            var tmpFrame      = frame
            tmpFrame.origin.y = newVal
            frame = tmpFrame
        }
    }
    
    /// bottom
    var bottom : CGFloat {
        
        get { return frame.origin.y + frame.size.height}
        
        set(newVal) {
            
            var tmpFrame      = frame
            tmpFrame.origin.y = newVal - frame.size.height
            frame             = tmpFrame
        }
    }
    
    /// centerX
    var centerX : CGFloat {
        
        get { return center.x}
        set(newVal) { center = CGPoint(x: newVal, y: center.y)}
    }
    
    /// centerY
    var centerY : CGFloat {
        
        get { return center.y}
        set(newVal) { center = CGPoint(x: center.x, y: newVal)}
    }
    
    /// middleX
    var middleX : CGFloat {
        
        get { return bounds.width / 2}
    }
    
    /// middleY
    var middleY : CGFloat {
        
        get { return bounds.height / 2}
    }
    
    /// middlePoint
    var middlePoint : CGPoint {
        
        get { return CGPoint(x: bounds.width / 2, y: bounds.height / 2)}
    }

}



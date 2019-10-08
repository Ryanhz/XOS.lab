//
//  UIButtonExtension.swift
//  zyme
//
//  Created by zyme on 2018/1/23.
//  Copyright © 2018年 zyme. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    struct ZymeAssociatedKeys {
        static var defaultInterval: TimeInterval = 0.5
        static var customInterval: UInt8 = 0
        static var isIgnoreInterval: UInt8 = 0
        static var swapMethodKey_delayClick = "com.UIButtonswapMethod.delayClick.zyme"
    }
}

// MARK: -防止连续点击
extension UIButton {
    var cutomInterval: TimeInterval {
        get {
            return zyme.associatedObject(key: &ZymeAssociatedKeys.customInterval) {
                return ZymeAssociatedKeys.defaultInterval
            }
        }
        set {
            zyme.associateSetObject(key: &ZymeAssociatedKeys.customInterval, value: newValue)
        }
    }
    
    var isIgnoreInterval: Bool {
        get {
            return zyme.associatedObject( key: &ZymeAssociatedKeys.isIgnoreInterval) {
                return false
            }
        }
        set {
            zyme.associateSetObject(key: &ZymeAssociatedKeys.isIgnoreInterval, value: newValue)
        }
    }
    
    class func swapMethod(){
        DispatchQueue.zyme.once(token: ZymeAssociatedKeys.swapMethodKey_delayClick) {
            let systemSel = #selector(UIButton.sendAction(_:to:for:))
            let swizzSel = #selector(UIButton.zymeSendAction(_:to:for:))
            
            let systemMethod = class_getInstanceMethod(self, systemSel)
            
            let swizzMethod = class_getInstanceMethod(self, swizzSel)
            
            let isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod!), method_getTypeEncoding(swizzMethod!))
            
            if isAdd {
                class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod!), method_getTypeEncoding(systemMethod!));
            }else {
                method_exchangeImplementations(systemMethod!, swizzMethod!);
            }
        }
    }
    
    @objc private dynamic func zymeSendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        if !isIgnoreInterval {
            isUserInteractionEnabled = false
            DispatchQueue.main.zyme.after(cutomInterval, execute: { [weak self] in
                self?.isUserInteractionEnabled = true
            })
        }
        zymeSendAction(action, to: target, for: event)
    }
    
}


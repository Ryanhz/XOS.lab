//
//  UIButtonExtension.swift
//  DidaSystem
//
//  Created by hzf on 2018/1/23.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    struct HzyAssociatedKeys {
        static var defaultInterval: TimeInterval = 0.5
        static var customInterval: UInt8 = 0
        static var isIgnoreInterval: UInt8 = 0
        static var swapMethodKey_delayClick = "com.UIButtonswapMethod.delayClick.hzy"
    }
}

// MARK: -防止连续点击
extension UIButton {
    var cutomInterval: TimeInterval {
        get {
            return hzy.associatedObject(key: &HzyAssociatedKeys.customInterval) {
                return HzyAssociatedKeys.defaultInterval
            }
        }
        set {
            hzy.associateSetObject(key: &HzyAssociatedKeys.customInterval, value: newValue)
        }
    }
    
    var isIgnoreInterval: Bool {
        get {
            return hzy.associatedObject( key: &HzyAssociatedKeys.isIgnoreInterval) {
                return false
            }
        }
        set {
            hzy.associateSetObject(key: &HzyAssociatedKeys.isIgnoreInterval, value: newValue)
        }
    }
    
    class func swapMethod(){
        DispatchQueue.hzy.once(token: HzyAssociatedKeys.swapMethodKey_delayClick) {
            let systemSel = #selector(UIButton.sendAction(_:to:for:))
            let swizzSel = #selector(UIButton.hzySendAction(_:to:for:))
            
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
    
    @objc private dynamic func hzySendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        if !isIgnoreInterval {
            isUserInteractionEnabled = false
            DispatchQueue.main.hzy.after(cutomInterval, execute: { [weak self] in
                self?.isUserInteractionEnabled = true
            })
        }
        hzySendAction(action, to: target, for: event)
    }
    
}


//
//  UIViewTouchable.swift
//  DidaSystem
//
//  Created by hzf on 2018/1/18.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import Foundation
import UIKit

private var isTouchableKey: UInt8 = 0
private var touchBlockKey: UInt8 = 0
private var tapGestureRecognizerKey: UInt8 = 0

@objc protocol Touchable: class  {
    @objc func zymeTouchAction()
}

extension UIView: Touchable {
    @objc func zymeTouchAction() {
        self.zyme.touchBlock?()
    }
}

extension ZymeNamespaceWrapper where T: UIView {
    
    fileprivate var tapGestureRecognizer: UITapGestureRecognizer {
        get {
            return associatedObject(key: &tapGestureRecognizerKey, {
                let tap =  UITapGestureRecognizer()
                tap.addTarget(wrappedValue, action: #selector(wrappedValue.zymeTouchAction))
                return tap
            })
        }
        
        set {
            associateSetObject(key: &tapGestureRecognizerKey, value: newValue)
        }
    }
    
    fileprivate var isTouchable: Bool {
        get {
            return associatedObject(key: &isTouchableKey, {return false})
        }
        set {
            associateSetObject(key: &isTouchableKey, value: newValue)
        }
    }
    
    var touchBlock: (()->Void)? {
        get {
            return associatedObject(key: &touchBlockKey)
        }
        set {
            if newValue != nil {
                isTouchable = wrappedValue.isUserInteractionEnabled
                wrappedValue.isUserInteractionEnabled = true
                wrappedValue.addGestureRecognizer(tapGestureRecognizer)
            } else {
                wrappedValue.isUserInteractionEnabled = isTouchable
                wrappedValue.removeGestureRecognizer(tapGestureRecognizer)
            }
            associateSetObject(key: &touchBlockKey, value: newValue)
        }
    }
    
    func click(_ block: (()->Void)?){
        touchBlock = block
    }
}

//
//  ZymeSwipeEndEditingable.swift
//  zyme
//
//  Created by zyme on 2018/1/24.
//  Copyright © 2018年 zyme. All rights reserved.
//

import Foundation
import UIKit
@objc protocol ZymeSwipeEndEditingable: UIGestureRecognizerDelegate {
//   @objc func zymeSwipeAction(_ recognizer: UISwipeGestureRecognizer)
}

private var _zymeDownSwipeKey: UInt8 = 0
private var _zymeUpSwipeKey: UInt8 = 0
private var _zymeisEndEditingWhenSwipeKey: UInt8 = 0

extension UIResponder {
    @objc func zymeSwipeAction(_ recognizer: UISwipeGestureRecognizer) {
        if let `self` = self as? UIViewController {
            self.view.endEditing(true)
            self.navigationController?.view.endEditing(true)
        }
        if let `self` = self as? UIView {
            self.endEditing(true)
        }
    }
}

extension ZymeNamespaceWrapper where T: UIResponder, T: ZymeSwipeEndEditingable {
    var downSwipeGestureRecognizer : UISwipeGestureRecognizer {
        set {
            associateSetObject(key: &_zymeDownSwipeKey, value: newValue)
        }
        get {
            return associatedObject(key: &_zymeDownSwipeKey, {
                let downSwipe = UISwipeGestureRecognizer(target: wrappedValue, action: #selector(UIResponder.zymeSwipeAction(_:)))
                downSwipe.delegate = wrappedValue //as? UIGestureRecognizerDelegate
                downSwipe.direction = .down
                downSwipe.isEnabled = isEndEditingWhenSwipe
                if let view = wrappedValue as? UIView {
                    view.addGestureRecognizer(downSwipe)
                } else if let vc = wrappedValue as? UIViewController {
                    vc.view.addGestureRecognizer(downSwipe)
                }
                return downSwipe
            })
        }
    }
    
    var upSwipeGestureRecognizer : UISwipeGestureRecognizer {
        set {
            associateSetObject(key: &_zymeUpSwipeKey, value: newValue)
        }
        get {
            return associatedObject(key: &_zymeUpSwipeKey, {
                let upSwipe = UISwipeGestureRecognizer(target: wrappedValue, action: #selector(UIResponder.zymeSwipeAction(_:)))
                upSwipe.delegate = wrappedValue //as? UIGestureRecognizerDelegate
                upSwipe.direction = .up
                upSwipe.isEnabled = isEndEditingWhenSwipe
               
                if let view = wrappedValue as? UIView {
                   view.addGestureRecognizer(upSwipe)
                } else if let vc = wrappedValue as? UIViewController {
                    vc.view.addGestureRecognizer(upSwipe)
                }
                return upSwipe
            })
        }
    }
    
    var isEndEditingWhenSwipe: Bool {
        set {
            guard isEndEditingWhenSwipe !=  newValue else {
                return
            }
            associateSetObject(key: &_zymeisEndEditingWhenSwipeKey, value: newValue)
            downSwipeGestureRecognizer.isEnabled = newValue
            upSwipeGestureRecognizer.isEnabled = newValue
        }
        
        get {
            return associatedObject(key:  &_zymeisEndEditingWhenSwipeKey, {return false})
        }
    }
}


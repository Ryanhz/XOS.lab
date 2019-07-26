//
//  HzySwipeEndEditingable.swift
//  DidaSystem
//
//  Created by hzf on 2018/1/24.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import Foundation
import UIKit
@objc protocol HzySwipeEndEditingable: UIGestureRecognizerDelegate {
//   @objc func hzySwipeAction(_ recognizer: UISwipeGestureRecognizer)
}

private var HzyDownSwipeKey: UInt8 = 0
private var HzyUpSwipeKey: UInt8 = 0
private var HzyisEndEditingWhenSwipeKey: UInt8 = 0

extension UIResponder {
    @objc func hzySwipeAction(_ recognizer: UISwipeGestureRecognizer) {
        if let `self` = self as? UIViewController {
            self.view.endEditing(true)
            self.navigationController?.view.endEditing(true)
        }
        if let `self` = self as? UIView {
            self.endEditing(true)
        }
    }
}

extension HzyNamespaceWrapper where T: UIResponder, T: HzySwipeEndEditingable {
    var downSwipeGestureRecognizer : UISwipeGestureRecognizer {
        set {
            associateSetObject(key: &HzyDownSwipeKey, value: newValue)
        }
        get {
            return associatedObject(key: &HzyDownSwipeKey, {
                let downSwipe = UISwipeGestureRecognizer(target: wrappedValue, action: #selector(UIResponder.hzySwipeAction(_:)))
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
            associateSetObject(key: &HzyUpSwipeKey, value: newValue)
        }
        get {
            return associatedObject(key: &HzyUpSwipeKey, {
                let upSwipe = UISwipeGestureRecognizer(target: wrappedValue, action: #selector(UIResponder.hzySwipeAction(_:)))
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
            associateSetObject(key: &HzyisEndEditingWhenSwipeKey, value: newValue)
            downSwipeGestureRecognizer.isEnabled = newValue
            upSwipeGestureRecognizer.isEnabled = newValue
        }
        
        get {
            return associatedObject(key:  &HzyisEndEditingWhenSwipeKey, {return false})
        }
    }
}


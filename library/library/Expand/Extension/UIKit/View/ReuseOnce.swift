//
//  ReuseOnce.swift
//  DidaSystem
//
//  Created by hzf on 2018/1/26.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import Foundation
import UIKit

private var isConfigKey: UInt8 = 0

protocol HzyReuseOnce {}

extension HzyNamespaceWrapper where T: UIView, T: HzyReuseOnce {
    
   private(set) var isConfig: Bool {
        get {
            return associatedObject(key: &isConfigKey, {return false})
        }
        set {
            associateSetObject(key: &isConfigKey, value: newValue)
        }
    }
    
    func onceConfig(block: ((T)->Void)?) {
        guard let block = block, isConfig == false else {
            return
        }
        isConfig = true
        block(wrappedValue)
    }
}

extension UIView: HzyReuseOnce {}

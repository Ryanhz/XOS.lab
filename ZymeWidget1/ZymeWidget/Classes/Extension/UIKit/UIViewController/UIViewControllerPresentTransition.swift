//
//  UIViewControllerTransition.swift
//  zyme
//
//  Created by zyme on 2018/5/18.
//  Copyright © 2018年 zyme. All rights reserved.
//

import Foundation
import UIKit

fileprivate var ZymetransitionDelegateKey: UInt8 = 0

extension ZymeNamespaceWrapper where T: UIViewController {
    
    fileprivate var zymeTransitioningDelegate: ZymeTransitioningDelegate? {
        set {
            wrappedValue.associateSetObject(key: &ZymetransitionDelegateKey, value: newValue)
        }
        get{
            return wrappedValue.associatedObject(key: &ZymetransitionDelegateKey)
        }
    }
    
    func present(_ viewControllertoPresent: UIViewController,
                    presentTransionStyle: ZymeTransitioningDelegate.PresentTransionStyle,
                    completion: (()->Void)? = nil){
        
        viewControllertoPresent.modalPresentationStyle = .custom
        self.zymeTransitioningDelegate = ZymeTransitioningDelegate(presentTransionStyle: presentTransionStyle)
        if let viewControllertoPresent = viewControllertoPresent as? ZymeTransitioningDelegateable {
            self.zymeTransitioningDelegate?.portrait = viewControllertoPresent.portrait
            self.zymeTransitioningDelegate?.landScape = viewControllertoPresent.landScape
            self.zymeTransitioningDelegate?.maskColor = viewControllertoPresent.maskColor
        }
        
        viewControllertoPresent.transitioningDelegate = self.zymeTransitioningDelegate
        DispatchQueue.main.async {
            self.wrappedValue.present(viewControllertoPresent, animated: true, completion: completion)
        }
    }
}

//
//  UINavigationControllerPush.swift
//  zyme
//
//  Created by zyme on 2018/5/22.
//  Copyright © 2018年 zyme. All rights reserved.
//

import Foundation
import UIKit

fileprivate var ZymeInteractionDelegateKey: UInt8 = 0
fileprivate var ZymeOriginalDelegateKey: UInt8 = 0
fileprivate var ZymeEdgePanKey: UInt8 = 0

fileprivate var ZymeCustomNavigationInteractiveTransitionOnceKey = "work.zyme.zymeCustomNavigationInteractiveTransitionOnceKey"

extension UINavigationController {
    
    class func changePushPopMethod(){
        
        DispatchQueue.zyme.once(token: ZymeCustomNavigationInteractiveTransitionOnceKey) {
            let systemSel = #selector(pushViewController(_:animated:))
            let swizzSel = #selector(zymePush(_:animated:))
            
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
    
    @objc fileprivate func zymePush(_ viewController: UIViewController, animated flag: Bool){
    
        if let delegate = self.delegate, delegate.isKind(of: ZymeInteractiveTransition.self) {
            self.delegate = self.zyme.originalDelegate
        }
        if let screenEdge = self.zyme.screenEdge  {
            self.view.removeGestureRecognizer(screenEdge)
        }
        zymePush(viewController, animated: flag)
    }
}

extension ZymeNamespaceWrapper where T: UINavigationController {

    fileprivate var originalDelegate: UINavigationControllerDelegate? {
        set {
            wrappedValue.associateSetUnownedObject(key: &ZymeOriginalDelegateKey, value: newValue)
        }
        get {
            return wrappedValue.associatedObject(key: &ZymeOriginalDelegateKey)
        }
    }
    
    fileprivate var screenEdge: UIScreenEdgePanGestureRecognizer? {
        set {
            wrappedValue.associateSetObject(key: &ZymeEdgePanKey, value: newValue)
        }
        get {
            return wrappedValue.associatedObject(key: &ZymeEdgePanKey)
        }
    }
    
    func pushViewController(viewController: UIViewController, animatedType: ZymeInteractiveTransition.AnimatedType = .none, animated flag: Bool) {
         UINavigationController.changePushPopMethod()
        let interactiveTransitionDelegate = ZymeInteractiveTransition(animatedType)
        interactiveTransitionDelegate.delegate = wrappedValue.delegate
        interactiveTransitionDelegate.navigationController = wrappedValue
        viewController.associateSetObject(key: &ZymeInteractionDelegateKey, value: interactiveTransitionDelegate)
        if originalDelegate == nil {
            originalDelegate = wrappedValue.delegate
        }
        wrappedValue.delegate = interactiveTransitionDelegate
        if let screenEdge = screenEdge {
            wrappedValue.view.removeGestureRecognizer(screenEdge)
        }
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: interactiveTransitionDelegate, action: #selector(ZymeInteractiveTransition.edgePanAction))
        edgePan.edges = .left
        wrappedValue.view.removeGestureRecognizer(edgePan)

        screenEdge = edgePan
        wrappedValue.view.addGestureRecognizer(edgePan)
        
        wrappedValue.zymePush(viewController, animated: flag)
    }
}

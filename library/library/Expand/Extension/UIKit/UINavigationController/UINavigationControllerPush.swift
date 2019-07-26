//
//  UINavigationControllerPush.swift
//  library
//
//  Created by Ranger on 2018/5/22.
//  Copyright © 2018年 hzy. All rights reserved.
//

import Foundation

fileprivate var HzyInteractionDelegateKey: UInt8 = 0
fileprivate var HzyOriginalDelegateKey: UInt8 = 0
fileprivate var HzyEdgePanKey: UInt8 = 0

fileprivate var HzyCustomNavigationInteractiveTransitionOnceKey = "com.hzy.HzyCustomNavigationInteractiveTransitionOnceKey"

extension UINavigationController {
    
    class func changePushPopMethod(){
        
        DispatchQueue.hzy.once(token: HzyCustomNavigationInteractiveTransitionOnceKey) {
            let systemSel = #selector(pushViewController(_:animated:))
            let swizzSel = #selector(hzyPush(_:animated:))
            
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
    
    @objc fileprivate func hzyPush(_ viewController: UIViewController, animated flag: Bool){
    
        if let delegate = self.delegate, delegate.isKind(of: HzyInteractiveTransition.self) {
            self.delegate = self.hzy.originalDelegate
        }
        if let screenEdge = self.hzy.screenEdge  {
            self.view.removeGestureRecognizer(screenEdge)
        }
        hzyPush(viewController, animated: flag)
    }
}

extension HzyNamespaceWrapper where T: UINavigationController {

    fileprivate var originalDelegate: UINavigationControllerDelegate? {
        set {
            wrappedValue.associateSetUnownedObject(key: &HzyOriginalDelegateKey, value: newValue)
        }
        get {
            return wrappedValue.associatedObject(key: &HzyOriginalDelegateKey)
        }
    }
    
    fileprivate var screenEdge: UIScreenEdgePanGestureRecognizer? {
        set {
            wrappedValue.associateSetObject(key: &HzyEdgePanKey, value: newValue)
        }
        get {
            return wrappedValue.associatedObject(key: &HzyEdgePanKey)
        }
    }
    
    func pushViewController(viewController: UIViewController, animatedType: HzyInteractiveTransition.AnimatedType = .none, animated flag: Bool) {
         UINavigationController.changePushPopMethod()
        DLog(wrappedValue.delegate)
        let interactiveTransitionDelegate = HzyInteractiveTransition(animatedType)
        interactiveTransitionDelegate.delegate = wrappedValue.delegate
        interactiveTransitionDelegate.navigationController = wrappedValue
        viewController.associateSetObject(key: &HzyInteractionDelegateKey, value: interactiveTransitionDelegate)
        if originalDelegate == nil {
            originalDelegate = wrappedValue.delegate
        }
        wrappedValue.delegate = interactiveTransitionDelegate
        if let screenEdge = screenEdge {
            wrappedValue.view.removeGestureRecognizer(screenEdge)
        }
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: interactiveTransitionDelegate, action: #selector(HzyInteractiveTransition.edgePanAction))
        edgePan.edges = .left
        wrappedValue.view.removeGestureRecognizer(edgePan)

        screenEdge = edgePan
        wrappedValue.view.addGestureRecognizer(edgePan)
        
        wrappedValue.hzyPush(viewController, animated: flag)
    }
}

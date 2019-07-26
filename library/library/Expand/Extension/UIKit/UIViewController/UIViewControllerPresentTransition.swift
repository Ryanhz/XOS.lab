//
//  UIViewController_transition.swift
//  library
//
//  Created by Ranger on 2018/5/18.
//  Copyright © 2018年 hzy. All rights reserved.
//

import Foundation

fileprivate var HzytransitionDelegateKey: UInt8 = 0

extension HzyNamespaceWrapper where T: UIViewController {
    
    fileprivate var hzyTransitioningDelegate: HzyTransitioningDelegate? {
        set {
            wrappedValue.associateSetObject(key: &HzytransitionDelegateKey, value: newValue)
        }
        get{
            return wrappedValue.associatedObject(key: &HzytransitionDelegateKey)
        }
    }
    
    func present(_ viewControllertoPresent: UIViewController,
                    presentTransionStyle: HzyTransitioningDelegate.PresentTransionStyle,
                    completion: (()->Void)? = nil){
        
        viewControllertoPresent.modalPresentationStyle = .custom
        self.hzyTransitioningDelegate = HzyTransitioningDelegate(presentTransionStyle: presentTransionStyle)
        if let viewControllertoPresent = viewControllertoPresent as? HzyTransitioningDelegateable {
            self.hzyTransitioningDelegate?.portrait = viewControllertoPresent.portrait
            self.hzyTransitioningDelegate?.landScape = viewControllertoPresent.landScape
            self.hzyTransitioningDelegate?.maskColor = viewControllertoPresent.maskColor
        }
        
        viewControllertoPresent.transitioningDelegate = self.hzyTransitioningDelegate
        DispatchQueue.main.async {
            self.wrappedValue.present(viewControllertoPresent, animated: true, completion: completion)
        }
    }
}

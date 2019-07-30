//
//  FlutterRouter.swift
//  laboratory
//
//  Created by hzf on 2019/7/29.
//  Copyright © 2019 zyme. All rights reserved.
//

import UIKit
import flutter_boost

class FlutterRouter: NSObject {

    var navigationController: UINavigationController?
    
    static let sharedRouter = FlutterRouter()
    
}

extension FlutterRouter: FLBPlatform {
    
    func openPage(_ name: String, params: [AnyHashable : Any], animated: Bool, completion: @escaping (Bool) -> Void) {
        
        let vc = FLBFlutterViewContainer()
        vc.setName(name, params: params)
        
        if let isPresent = params["present"] as? Bool, isPresent {
            self.navigationController?.present(vc, animated: animated, completion: {})
        } else {
            self.navigationController?.pushViewController(vc, animated: animated);
        }
    }
    
    func closePage(_ uid: String, animated: Bool, params: [AnyHashable : Any], completion: @escaping (Bool) -> Void) {
        
        
        if let vc = self.navigationController?.presentedViewController as? FLBFlutterViewContainer,
            vc.uniqueIDString == uid
            {
                vc.dismiss(animated: animated) {
                    
                }
        } else {
            self.navigationController?.popViewController(animated: animated)
        }
    }
    
}

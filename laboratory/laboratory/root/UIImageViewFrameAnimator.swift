//
//  ZGifLoadingView.swift
//  laboratory
//
//  Created by hzf on 2019/7/30.
//  Copyright © 2019 zyme. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices
import Zyme

private var _frameAnimationKey: UInt8 = 0

extension UIImageView: CAAnimationDelegate  {
    
    func makeKeyFrameWith(paths: [String]) {
        
        guard frameAnimation == nil else {
            return
        }
        
        let values = paths.compactMap { UIImage(contentsOfFile: $0)?.cgImage }
        
        self.frameAnimation = CAKeyframeAnimation(keyPath: "contents")
        
        frameAnimation!.delegate = self;
        frameAnimation?.setValue("zyme.frameAnimation", forKey: "name")
        frameAnimation!.duration = values.count.double / 10
        frameAnimation!.values = values
        frameAnimation!.isRemovedOnCompletion = false
        self.layer.add(frameAnimation!, forKey: "zyme.frameAnimation");
    }
    
    var frameAnimation: CAKeyframeAnimation? {
        get {
            return self.associatedObject(key: &_frameAnimationKey)
        }
        
        set {
            self.associateSetObject(key: &_frameAnimationKey, value: newValue)
        }
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if "zyme.frameAnimation" == anim.value(forKey: "name") as? String {
            self.layer.removeAnimation(forKey: "frameAnimation")
        }
    }
}

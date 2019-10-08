//
//  ZymePresentAnimation.swift
//  zyme
//
//  Created by zyme on 2018/5/18.
//  Copyright © 2018年 zyme. All rights reserved.
//

import UIKit

class ZymePresentBackScaleAnimation: NSObject, ZymeTransitioningAnimatorable {
    var isPresent: Bool
    
    override init() {
        self.isPresent = true
    }
    
    /// 动画执行的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    /// 获取`转场的上下文`:可以通过转场上下文获取弹出的View和消失的View
    // UITransitionContextFromViewKey : 获取消失的View
    // UITransitionContextToViewKey : 获取弹出的View
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
     
        isPresent ? animationForPresentedView(transitionContext) : animationForDismissedView(transitionContext)
    }
    
    /// 自定义弹出动画
    fileprivate func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning) {
//        let toVC = transitionContext.viewController(forKey: .to)!
        let toView = transitionContext.view(forKey: .to)!
        toView.transform = CGAffineTransform(translationX: 0, y: toView.height)
        transitionContext.containerView.addSubview(toView)
        toView.layer.zPosition = CGFloat(MAXFLOAT)
        
        let containerView = transitionContext.containerView
        let fromeVC = transitionContext.viewController(forKey: .from)!
        let fromView = fromeVC.view!//transitionContext.view(forKey: .from)!

        fromView.layer.zPosition = -1
        fromView.layer.frame = CGRect(x: 0, y: containerView.height/2, width: containerView.width, height: containerView.height)
        fromView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        var rotate = CATransform3DIdentity
        rotate.m34 = -1.0/1000
        let angle = (containerView.height == 812 ? 5 : 3) * Double.pi.cgFloat/180
        rotate = CATransform3DRotate(rotate, angle, 1, 0, 0)
        
        var scale = CATransform3DIdentity
        let sx: CGFloat = containerView.height == 812 ? 0.94 : 0.95
        let sy: CGFloat = containerView.height == 812 ? 0.96 : 0.957
        scale = CATransform3DScale(scale, sx, sy, 1)
        
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options:  [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                fromView.layer.transform = rotate
                fromView.alpha = 0.6
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6, animations: {
                fromView.alpha = 0.5
                fromView.layer.transform = scale
            })
            toView.transform = .identity
        }) { (finished) in
             transitionContext.completeTransition(true)
        }
    }
    
    /// 自定义消失动画
    fileprivate func animationForDismissedView(_ transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toVC = transitionContext.viewController(forKey: .to)!
        let toView = toVC.view!  // transitionContext.view(forKey: .to)!
        
        ///消失的view
        let fromView = transitionContext.view(forKey: .from)!
        var rotate = CATransform3DIdentity
        rotate.m34 = -1.0/1000
        let angle = 5 * Double.pi.cgFloat/180
        rotate = CATransform3DRotate(rotate, angle, 1, 0, 0)
    
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                toView.layer.transform = rotate
                toView.alpha = 0.6
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6, animations: {
                toView.alpha = 1
                toView.layer.transform = CATransform3DIdentity
            })
            fromView.transform = CGAffineTransform(translationX: 0, y: toView.height)
            
        }) { (finished) in
            toView.layer.zPosition = 0
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            toView.layer.frame = CGRect(x: 0, y: 0, width: containerView.width, height: containerView.height)
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}


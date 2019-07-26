
//
//  HzyPresentRightToLeftAnimation.swift
//  library
//
//  Created by Ranger on 2018/5/18.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit

class HzyPresentSimpleAnimation: NSObject, HzyTransitioningAnimatorable {
    
    enum HzyTranslationStyle {
        case rightToLeft, leftToRight, bottomToTop, show
    }
    
    var isPresent: Bool
    var translationStyle: HzyTranslationStyle
    init(_ translationStyle: HzyTranslationStyle) {
        self.isPresent = true
        self.translationStyle = translationStyle
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
        // 1.获取弹出的View
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        transitionContext.containerView.addSubview(toView)
        // 3.执行动画
        
        switch translationStyle {
        case .bottomToTop:
            toView.transform = CGAffineTransform(translationX: 0, y: toView.height)
        case .rightToLeft:
            toView.transform = CGAffineTransform(translationX: toView.width, y: 0)
        case .leftToRight:
            toView.transform = CGAffineTransform(translationX: -toView.width, y: 0)
        case .show:
            toView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            toView.transform = CGAffineTransform.identity
        }, completion: { (_) -> Void in
            // 必须告诉转场上下文你已经完成动画
            transitionContext.completeTransition(true)
        })
    }
    
    /// 自定义消失动画
    fileprivate func animationForDismissedView(_ transitionContext: UIViewControllerContextTransitioning) {
        // 1.获取消失的View
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        // 2.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            
            switch self.translationStyle {
            case .bottomToTop:
                dismissView?.transform = CGAffineTransform(translationX: 0, y: dismissView!.height)
            case .rightToLeft:
                dismissView?.transform = CGAffineTransform(translationX: dismissView!.width, y: 0)
            case .leftToRight:
                dismissView?.transform = CGAffineTransform(translationX: -dismissView!.width, y: 0)
            case .show:
                dismissView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }
            
        }, completion: { (_) -> Void in
            dismissView?.removeFromSuperview()
            // 必须告诉转场上下文你已经完成动画
            transitionContext.completeTransition(true)
        })
    }
}

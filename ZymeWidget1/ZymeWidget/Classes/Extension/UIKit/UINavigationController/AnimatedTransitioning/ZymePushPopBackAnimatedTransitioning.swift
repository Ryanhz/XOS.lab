//
//  ZymePushBackAnimatedTransitioning.swift
//  zyme
//
//  Created by zyme on 2018/5/22.
//  Copyright © 2018年 zyme. All rights reserved.
//

import UIKit

class ZymePushPopBackAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    var isPush: Bool = true
    weak var delegate: UINavigationControllerDelegate?
    weak var navigationController: UINavigationController?
    
    init(isPush: Bool) {
        self.isPush = isPush
    }
    
    /// 动画执行的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPush ? animationForPush(transitionContext) : animationForPop(transitionContext)
    }
    
    fileprivate func animationForPush(_ transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.view(forKey: .to)!
        toView.frame = transitionContext.containerView.bounds
        transitionContext.containerView.addSubview(toView)
        
        let fromView = transitionContext.view(forKey: .from)!
        toView.x = toView.width
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.x = 0
            fromView.transform = .init(scaleX: 0.93, y: 0.93)
        }) { (finished) in
            toView.x = 0
            fromView.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    fileprivate func animationForPop(_ transitionContext: UIViewControllerContextTransitioning) {
        
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        
        toView.frame = transitionContext.containerView.bounds
        transitionContext.containerView.addSubview(toView)
        transitionContext.containerView.bringSubviewToFront(fromView)
        
        toView.transform = .init(scaleX: 0.93, y: 0.93)
        let origin = fromView.frame
        UIView.animate(withDuration: 0.3, animations: {
            fromView.x = fromView.width
            toView.transform = .identity
        }) { (finished) in
            fromView.frame = origin
            toView.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

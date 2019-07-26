//
//  HzyPushPopAnimator.swift
//  DidaSystem
//
//  Created by hzf on 2017/6/15.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit

class HzyPushPopAnimator: NSObject  {

    var isPush : Bool = true
}

extension HzyPushPopAnimator: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            isPush = true
        } else {
            isPush = false
        }
        return self
    }
}

extension HzyPushPopAnimator: UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPush ? animationForPresentedView(transitionContext) : animationForDismissedView(transitionContext)
    }
    
    fileprivate func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from)! //homeVC
        let toVC = transitionContext.viewController(forKey: .to)! //infoVC
        
        _ = fromVC.tabBarController!
//        tableBarController.view.height += 49
        let bounds = UIScreen.mainbounds
        toVC.view.transform = CGAffineTransform(translationX: 0, y: bounds.height)
        transitionContext.containerView.addSubview(toVC.view)
//        transitionContext.containerView.backgroundColor = UIColor.clear
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            toVC.view.transform = CGAffineTransform.identity
        }, completion: { (_) -> Void in
//            tableBarController.view.height -= 49
            transitionContext.completeTransition(true)
        })
    }
    
    fileprivate func animationForDismissedView(_ transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)! //homeVC
        let tableBarController = toVC.tabBarController!
//        let bounds = UIScreen.mainbounds
//        let fromSnpView = fromVC.view.snapshotView(afterScreenUpdates: true)!
//        fromSnpView.transform = CGAffineTransform(translationX: 0, y: 0)
        
        transitionContext.containerView.addSubview(toVC.view)
        tableBarController.view.addSubview(fromVC.view)
//        tableBarController.view.addSubview(fromSnpView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
//            fromSnpView.transform = CGAffineTransform(translationX: 0, y: bounds.height)
        }, completion: { (_) -> Void in
//            fromSnpView.removeFromSuperview()
            fromVC.view.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}

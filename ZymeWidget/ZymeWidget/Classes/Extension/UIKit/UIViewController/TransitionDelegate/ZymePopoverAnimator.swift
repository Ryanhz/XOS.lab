//
//  zymePopoverAnimator.swift
//  zyme
//
//  Created by zyme on 16/4/6.
//  Copyright © 2016年 zyme. All rights reserved.
//

import UIKit

enum ZymePopoverAnimatorStyle {
    case rightToLeft, bottomToTop, show
}

class ZymePopoverAnimator: NSObject {
    
    fileprivate var isPresented : Bool = false
    // MARK:- 对外提供的属性
    var presentedFrame : CGRect = CGRect.zero
    
    ///横屏
    var presentedLandscapeFrame: CGRect = .zero
    
    var style: ZymePopoverAnimatorStyle = .bottomToTop
    
    var callBack : ((_ presented : Bool) -> ())?
    
    deinit {}
    // MARK:- 自定义构造函数
    // 注意:如果自定义了一个构造函数,但是没有对默认构造函数init()进行重写,那么自定义的构造函数会覆盖默认的init()构造函数
    init(callBack : @escaping (_ presented : Bool) -> Void) {
        self.callBack = callBack
    }
}

// MARK:- 自定义转场代理的方法
extension ZymePopoverAnimator : UIViewControllerTransitioningDelegate {
    // 目的:改变弹出View的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentation = ZymePresentationController(presentedViewController: presented, presenting: presenting)
        presentation.presentedPortraitFrame = presentedFrame
        presentation.presentedLandscapeFrame = presentedLandscapeFrame
        return presentation
    }
    
    // 目的:自定义弹出的动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        callBack!(isPresented)
        return self
    }
    
    // 目的:自定义消失的动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callBack!(isPresented)
        return self
    }
}


// MARK:- 弹出和消失动画代理的方法
extension ZymePopoverAnimator : UIViewControllerAnimatedTransitioning {
    /// 动画执行的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    /// 获取`转场的上下文`:可以通过转场上下文获取弹出的View和消失的View
    // UITransitionContextFromViewKey : 获取消失的View
    // UITransitionContextToViewKey : 获取弹出的View
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissedView(transitionContext)
    }
    
    /// 自定义弹出动画
    fileprivate func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning) {
        // 1.获取弹出的View
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        transitionContext.containerView.addSubview(toView)
        // 3.执行动画
        
        switch style {
        case .bottomToTop:
            toView.transform = CGAffineTransform(translationX: 0, y: toView.height)
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        case .rightToLeft:
            toView.transform = CGAffineTransform(translationX: toView.width, y: 0)
            toView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        case .show:
            toView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
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
            
            switch self.style {
            case .bottomToTop:
                dismissView?.transform = CGAffineTransform(translationX: 0, y: dismissView!.height)
            case .rightToLeft:
                dismissView?.transform = CGAffineTransform(translationX: dismissView!.width, y: 0)
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

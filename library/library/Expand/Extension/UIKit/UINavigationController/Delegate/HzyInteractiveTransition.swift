//
//  HzyInteractiveTransition.swift
//  library
//
//  Created by Ranger on 2018/5/22.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit

protocol HzyPushPopAnimatedTransitioningable: UIViewControllerAnimatedTransitioning{
    var isPop: Bool {get set}
    var delegate: UINavigationControllerDelegate? {get set}
    var navigationController: UINavigationController? {get set}
}

class HzyInteractiveTransition: UIPercentDrivenInteractiveTransition {

    var isPop: Bool = true
    var isInteracting: Bool = false
    weak var delegate: UINavigationControllerDelegate?
    weak var navigationController: UINavigationController?
    var animatedTransitioning: UIViewControllerAnimatedTransitioning!
    
    enum AnimatedType {
        case none
        case backScale
        case targetViewScale
    }
    
    var animatedType: AnimatedType
    
    
    deinit {
        DLog("——————————————————————————")
    }
    
    init(_ animatedType: AnimatedType) {
        self.animatedType = animatedType
    }
    
    @objc func edgePanAction(gesture: UIScreenEdgePanGestureRecognizer) {
        let rate = gesture.translation(in: UIApplication.shared.keyWindow!).x/UIScreen.width
        DLog(rate)
        func finishOrCancel() {
            let translation = gesture.translation(in: UIApplication.shared.keyWindow!)
            let percent = translation.x / UIApplication.shared.keyWindow!.bounds.width
            let velocityX = gesture.velocity(in: UIApplication.shared.keyWindow!).x
            let isFinished: Bool
            
            // 修改这里可以改变手势结束时的处理
            if velocityX > 100 {
                isFinished = true
            } else if percent > 0.5 {
                isFinished = true
            } else {
                isFinished = false
            }
            
            isFinished ? finish() : cancel()
        }
        
        switch gesture.state {
        case .began:
            isInteracting = true
            if navigationController?.viewControllers.count ?? 0 > 0 {
                navigationController?.popViewController(animated: true)
            }
            
        case .changed:
            if isInteracting {
                let percent = max(rate, 0)
                update(percent)
            }
        case .ended:
            if isInteracting {
                finishOrCancel()
                isInteracting = false
            }
        default:
            isInteracting = false
            self.cancel()
        }
    }
}

extension HzyInteractiveTransition: UINavigationControllerDelegate {
    
    // 交互
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard isInteracting, isPop else {
            return nil
        }
        return self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      
        isPop = false
        switch operation {
        case .pop:
            isPop = true
            switch animatedType {
            case .backScale:
                return HzyPushPopBackAnimatedTransitioning(isPush: false)
            case .targetViewScale:
                return  getTargetViewScaleAnimatedTransitioning(isPop: true, from: fromVC, to: toVC)
            default:
                return nil
            }
        case .push:
            switch animatedType {
            case .backScale:
                return HzyPushPopBackAnimatedTransitioning(isPush: true)
            case .targetViewScale:

                return getTargetViewScaleAnimatedTransitioning(isPop: false, from: fromVC, to: toVC)
            default:
                return nil
            }
        default:
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        delegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        delegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        
        return self.delegate?.navigationControllerSupportedInterfaceOrientations?(navigationController) ?? .portrait
    }
    
    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        
        return self.delegate?.navigationControllerPreferredInterfaceOrientationForPresentation?(navigationController) ?? .unknown
    }
    
    
    func getTargetViewScaleAnimatedTransitioning( isPop: Bool, from fromVC: UIViewController, to toVC: UIViewController) -> HzyPushPopScaleAnimatedTransitioning? {
        if isPop {
            guard let fromP = fromVC as? HzyPushPopScaleAnimatedTransitioningable,
                let toP = toVC as? HzyPushPopScaleAnimatedTransitioningable,
                let _ = fromP.transitionAnimationTargetView,
                let _ = toP.transitionAnimationSourceView
                else {
                    return nil
            }
        } else {
            guard let fromP = fromVC as? HzyPushPopScaleAnimatedTransitioningable,
                let toP = toVC as? HzyPushPopScaleAnimatedTransitioningable,
                let _ = fromP.transitionAnimationSourceView,
                let _ = toP.transitionAnimationTargetView
                else {
                    return nil
            }
        }
        return HzyPushPopScaleAnimatedTransitioning(isPush: !isPop)
    }
}

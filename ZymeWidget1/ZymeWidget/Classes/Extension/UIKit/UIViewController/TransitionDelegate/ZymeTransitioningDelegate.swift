//
//  ZymeTransitioningDelegate.swift
//  zyme
//
//  Created by zyme on 2018/5/18.
//  Copyright © 2018年 zyme. All rights reserved.
//

import UIKit

protocol ZymeTransitioningDelegateable {
    var portrait: CGRect? {get set}
    var landScape: CGRect? {get set}
    var maskColor: UIColor? {get set}
}

protocol ZymeTransitioningAnimatorable: UIViewControllerAnimatedTransitioning {
    var isPresent: Bool{get set}
}

class ZymeTransitioningDelegate: NSObject {

    enum PresentTransionStyle: String {
        case circle = "circle"
        case backScale = "backScale"
        case rightToLeft = "rightToLeft"
        case leftToRight = "leftToRight"
        case bottomToTop = "bottomToTop"
        case show = "show"
    }
    
    fileprivate var presentTransionStyle: PresentTransionStyle
    fileprivate var animator: ZymeTransitioningAnimatorable
    
    var portrait: CGRect?
    var landScape: CGRect?
    var maskColor: UIColor?
    
    init(presentTransionStyle: PresentTransionStyle) {
        self.presentTransionStyle = presentTransionStyle
        switch presentTransionStyle {
        case .bottomToTop:
             self.animator = ZymePresentSimpleAnimation(.bottomToTop)
        case .leftToRight:
            self.animator = ZymePresentSimpleAnimation(.leftToRight)
        case .rightToLeft:
            self.animator = ZymePresentSimpleAnimation(.rightToLeft)
        case .show:
            self.animator = ZymePresentSimpleAnimation(.show)
        default:
            self.animator = ZymePresentBackScaleAnimation()
        }
    }
}

// MARK:- 自定义转场代理的方法
extension ZymeTransitioningDelegate : UIViewControllerTransitioningDelegate {

    // 目的:改变弹出View的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = ZymePresentationController(presentedViewController: presented, presenting: presenting)
        if  presentTransionStyle != .circle {
            presentation.presentedPortraitFrame = portrait
            presentation.presentedLandscapeFrame = landScape
            presentation.maskBackgroundColor = maskColor
        }
        return presentation
    }
    
    // 目的:自定义弹出的动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
         animator.isPresent = true
        return animator
    }
    
    // 目的:自定义消失的动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresent =  false
        return animator 
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}






//
//  XMGPresentationController.swift
//  DS11WB
//
//  Created by hzf on 16/4/6.
//  Copyright © 2016年 hzf. All rights reserved.
//

import UIKit

class HzyPresentationController: UIPresentationController {
    // MARK:- 对外提供属性
    var presentedPortraitFrame : CGRect?
    ///横屏
    var presentedLandscapeFrame: CGRect?
    // MARK:- 懒加载属性
    fileprivate lazy var coverView : UIView = UIView()
    
    var maskBackgroundColor: UIColor?
    
    // MARK:- 系统回调函数
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        // 1.设置弹出View的尺寸
        presentedView?.frame = frameOfPresentedViewInContainerView
        // 2.添加蒙版
        setupCoverView()
    }
    
    //计算presentedView的frame
    override var frameOfPresentedViewInContainerView: CGRect {
        if presentedViewController.preferredInterfaceOrientationForPresentation.isPortrait  {
            //竖屏
            guard let presentedPortraitFrame = presentedPortraitFrame, presentedPortraitFrame != .zero else {
                return containerView!.bounds
            }
            return presentedPortraitFrame
        } else {
            
            guard let presentedLandscapeFrame = presentedLandscapeFrame, presentedLandscapeFrame != .zero else {
                
                guard let presentedPortraitFrame = presentedPortraitFrame, presentedPortraitFrame != .zero else {
                    return containerView!.bounds
                }
                
//                DLog("presentedPortraitFrame: \(presentedPortraitFrame)")
//                DLog("containerView?.frame\(containerView?.frame)")
                
                let x_scale = presentedPortraitFrame.origin.x / containerView!.height
                let y_scale = presentedPortraitFrame.origin.y / containerView!.width
                let width_scale = presentedPortraitFrame.size.width / containerView!.height
              
                let height_scale = presentedPortraitFrame.size.height / containerView!.width
                
                let frame = CGRect(x: x_scale * containerView!.width, y: y_scale * containerView!.height, width: width_scale * containerView!.width, height: height_scale*containerView!.height)
                
//                DLog(frame)
                
                return frame
            }
            return presentedLandscapeFrame
        }
    }
}

// MARK:- 设置UI界面相关
extension HzyPresentationController {
    fileprivate func setupCoverView() {
        // 1.添加蒙版
        containerView?.insertSubview(coverView, at: 0)
        
        // 2.设置蒙版的属性 UIColor.black
        coverView.backgroundColor = maskBackgroundColor 
        coverView.frame = containerView!.bounds
        
        if let gestureRecognizers =  coverView.gestureRecognizers {
            for gest in gestureRecognizers {
                coverView.removeGestureRecognizer(gest)
            }
        }
        // 3.添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(coverViewClick))
        coverView.addGestureRecognizer(tapGes)
    }
}

// MARK:- 事件监听
extension HzyPresentationController {
    @objc fileprivate func coverViewClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}












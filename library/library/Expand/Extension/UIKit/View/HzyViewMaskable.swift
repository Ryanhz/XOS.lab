//
//  HzyViewMaskable.swift
//  DidaSystem
//
//  Created by hzf on 2018/2/26.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import UIKit

extension UIRectCorner {
    static let top: UIRectCorner  = [.topLeft, .topRight]
    static let bottom: UIRectCorner = [.bottomLeft, .bottomRight]
    static let left: UIRectCorner = [.topLeft, .bottomLeft]
    static let right: UIRectCorner = [.topRight, .bottomRight]
    static let all: UIRectCorner = UIRectCorner.allCorners
}

protocol HzyViewMaskable {}

extension HzyViewMaskable where Self: UIView {
    /**
     对UIView及其子类进行上边或者下边切角
     
     - parameter view:  需要切割的View
     - parameter isTop: 是否是上边界
     */
    func cornerRadii(cornerTypes: UIRectCorner, cornerRadii: CGSize){
        let maskPath : UIBezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornerTypes , cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

extension UIView: HzyViewMaskable{}




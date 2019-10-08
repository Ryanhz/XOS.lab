//
//  ZymeBadgeable.swift
//  zyme
//
//  Created by zyme on 2017/11/1.
//  Copyright © 2017年 zyme. All rights reserved.
//

import UIKit

private  var _zymeBadgeLabelKey: UInt8 = 0
private  var _zymeBadgeValueKey: UInt8 = 0

private enum ZymeBadgeConstraintType: String {
    case top = "com.badgeLabel.Constraint.top"
    case right = "com.badgeLabel.Constraint.right"
    case minWidth = "com.badgeLabel.Constraint.minWidth"
    case height = "com.badgeLabel.Constraint.height"
}

public protocol ZymeBadgeable {}

@IBDesignable open class ZymePaddingLabel: UILabel {
    
    @IBInspectable public var topInset: CGFloat = 3 {
        didSet{
            layoutIfNeeded()
        }
    }
    @IBInspectable public var bottomInset: CGFloat = 3 {
        didSet{
            layoutIfNeeded()
        }
    }
    @IBInspectable public var leftInset: CGFloat = 3 {
        didSet{
            layoutIfNeeded()
        }
    }
    @IBInspectable public var rightInset: CGFloat = 3 {
        didSet{
            layoutIfNeeded()
        }
    }
    
    override open func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        let frame = rect.inset(by: insets)
        super.drawText(in: frame)
    }
    
    override open var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}

extension ZymeBadgeable where Self: UIView {
    
    public var badgeLabel: ZymePaddingLabel {
        //        set {
        //             zyme.associateSetObject(key: &ZymeBadgeLabelKey, value: newValue)
        //        }
        get{
            let setConstraint: ( ZymePaddingLabel ) ->Void = {[weak self] (label) in
                guard let `self` = self else {
                    return
                }
                let widthConstraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 16)
                
                let heightConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 16)
                
                let topConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 1)
                
                let rightConstraint = NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 1)
                
                widthConstraint.identifier = ZymeBadgeConstraintType.minWidth.rawValue
                heightConstraint.identifier = ZymeBadgeConstraintType.height.rawValue
                topConstraint.identifier = ZymeBadgeConstraintType.top.rawValue
                rightConstraint.identifier = ZymeBadgeConstraintType.right.rawValue
                //添加多个约束
                label.superview?.addConstraint(topConstraint)
                label.superview?.addConstraint(rightConstraint)
                label.addConstraint(widthConstraint)
                label.addConstraint(heightConstraint)
            }
            
            return zyme.associatedObject(key: &_zymeBadgeLabelKey, {
                let label = ZymePaddingLabel()
                label.backgroundColor = UIColor.zyme.color(rgb: 0xE1514F)
                label.font = UIFont.systemFont(ofSize: 10)
                label.textAlignment = .center
                label.textColor = UIColor.white
                label.layer.cornerRadius = 8
                label.layer.masksToBounds = true
                label.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(label)
                setConstraint(label)
                return label
            })
        }
    }
    
    public var badgeValue: String? {
        get {
            return zyme.associatedObject(key: &_zymeBadgeValueKey)
        }
        set {
            zyme.associateSetObject(key: &_zymeBadgeValueKey, value: newValue)
            updataBadge()
        }
    }
    
    func updataBadge(){
        guard let value = badgeValue else {
            badgeLabel.isHidden = true
            return
        }
        badgeLabel.isHidden = false
        badgeLabel.text = value
    }
    
    public var badgeRight: CGFloat {
        set {
            badgeLabel.superview?.constraints.filter({return $0.identifier == ZymeBadgeConstraintType.right.rawValue}).first?.constant = newValue
        }
        
        get {
            return badgeLabel.superview?.constraints.filter({return $0.identifier == ZymeBadgeConstraintType.right.rawValue}).first?.constant ?? 0
        }
    }
    
    public var badgeTop: CGFloat {
        set {
            badgeLabel.superview?.constraints.filter({return $0.identifier == ZymeBadgeConstraintType.top.rawValue}).first?.constant = newValue
        }
        
        get {
            return badgeLabel.superview?.constraints.filter({return $0.identifier == ZymeBadgeConstraintType.top.rawValue}).first?.constant ?? 0
        }
    }
    
    
    public var badgeMinWidth: CGFloat {
        set {
            badgeLabel.constraints.filter({return $0.identifier == ZymeBadgeConstraintType.minWidth.rawValue}).first?.constant = newValue
        }
        
        get {
            return badgeLabel.constraints.filter({return $0.identifier == ZymeBadgeConstraintType.minWidth.rawValue}).first?.constant ?? 0
        }
    }
    
    public var badgeHeight: CGFloat {
        set {
            badgeLabel.constraints.filter({return $0.identifier == ZymeBadgeConstraintType.height.rawValue}).first?.constant = newValue
        }
        
        get {
            return badgeLabel.constraints.filter({return $0.identifier == ZymeBadgeConstraintType.height.rawValue}).first?.constant ?? 0
        }
    }
}

extension UIView: ZymeBadgeable{}


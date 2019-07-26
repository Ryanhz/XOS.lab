//
//  HzyBadgeable.swift
//  FETools
//
//  Created by hzf on 2017/11/1.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit

private  var HzyBadgeLabelKey: UInt8 = 0
private  var HzyBadgeValueKey: UInt8 = 0

private enum HzyBadgeConstraintType: String {
    case top = "com.badgeLabel.Constraint.top"
    case right = "com.badgeLabel.Constraint.right"
    case minWidth = "com.badgeLabel.Constraint.minWidth"
    case height = "com.badgeLabel.Constraint.height"
}

protocol HzyBadgeable {}

extension HzyBadgeable where Self: UIView {
    
    var badgeLabel: HzyPaddingLabel {
        set {
             hzy.associateSetObject(key: &HzyBadgeLabelKey, value: newValue)
        }
        
        get{
            let setConstraint: ( HzyPaddingLabel ) ->Void = {[weak self] (label) in
                guard let `self` = self else {
                    return
                }
                let widthConstraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 16)
                
                let heightConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 16)
          
                let topConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 1)
              
                let rightConstraint = NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 1)
                
                widthConstraint.identifier = HzyBadgeConstraintType.minWidth.rawValue
                heightConstraint.identifier = HzyBadgeConstraintType.height.rawValue
                topConstraint.identifier = HzyBadgeConstraintType.top.rawValue
                rightConstraint.identifier = HzyBadgeConstraintType.right.rawValue
                //添加多个约束
                label.superview?.addConstraint(topConstraint)
                label.superview?.addConstraint(rightConstraint)
                label.addConstraint(widthConstraint)
                label.addConstraint(heightConstraint)
            }
            
            return hzy.associatedObject(key: &HzyBadgeLabelKey,{
                let label = HzyPaddingLabel()
                label.backgroundColor = UIColor.hzy.color(rgb: 0xE1514F)
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
    
    var badgeValue: String? {
        get {
            return hzy.associatedObject(key: &HzyBadgeValueKey)
        }
        set {
            hzy.associateSetObject(key: &HzyBadgeValueKey, value: newValue)
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
    
    var badgeRight: CGFloat {
        set {
            badgeLabel.superview?.constraints.filter({return $0.identifier == HzyBadgeConstraintType.right.rawValue}).first?.constant = newValue
        }
        
        get {
            return badgeLabel.superview?.constraints.filter({return $0.identifier == HzyBadgeConstraintType.right.rawValue}).first?.constant ?? 0
        }
    }
    
    var badgeTop: CGFloat {
        set {
            badgeLabel.superview?.constraints.filter({return $0.identifier == HzyBadgeConstraintType.top.rawValue}).first?.constant = newValue
        }
        
        get {
            return badgeLabel.superview?.constraints.filter({return $0.identifier == HzyBadgeConstraintType.top.rawValue}).first?.constant ?? 0
        }
    }

    
    var badgeMinWidth: CGFloat {
        set {
            badgeLabel.constraints.filter({return $0.identifier == HzyBadgeConstraintType.minWidth.rawValue}).first?.constant = newValue
        }
        
        get {
            return badgeLabel.constraints.filter({return $0.identifier == HzyBadgeConstraintType.minWidth.rawValue}).first?.constant ?? 0
        }
    }
    
    var badgeHeight: CGFloat {
        set {
            badgeLabel.constraints.filter({return $0.identifier == HzyBadgeConstraintType.height.rawValue}).first?.constant = newValue
        }
        
        get {
            return badgeLabel.constraints.filter({return $0.identifier == HzyBadgeConstraintType.height.rawValue}).first?.constant ?? 0
        }
    }
}

extension UIButton: HzyBadgeable{}


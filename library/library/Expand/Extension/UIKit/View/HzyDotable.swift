//
//  HzyDotable.swift
//  DidaSystem
//
//  Created by hzf on 2018/2/7.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import UIKit

private  var HzyDotKey: UInt8 = 0

private enum HzyDotConstraintType: String {
    case top = "com.dot.Constraint.top"
    case right = "com.dot.Constraint.right"
    case width = "com.dot.Constraint.minWidth"
    case height = "com.dot.Constraint.height"
}

protocol HzyDotable {}

extension HzyDotable where Self: UIView {
    
    var dotView: UIView {
        set {
            hzy.associateSetObject(key: &HzyDotKey, value: newValue)
        }
        
        get{
            let setConstraint: ( UIView ) ->Void = {[weak self] (dot) in
                guard let `self` = self else {
                    return
                }
                let widthConstraint = NSLayoutConstraint(item: dot, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 4)
                
                let heightConstraint = NSLayoutConstraint(item: dot, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 4)
                
                let topConstraint = NSLayoutConstraint(item: dot, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 1)
                
                let rightConstraint = NSLayoutConstraint(item: dot, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 1)
                
                widthConstraint.identifier = HzyDotConstraintType.width.rawValue
                heightConstraint.identifier = HzyDotConstraintType.height.rawValue
                topConstraint.identifier = HzyDotConstraintType.top.rawValue
                rightConstraint.identifier = HzyDotConstraintType.right.rawValue
                //添加多个约束
                dot.superview?.addConstraint(topConstraint)
                dot.superview?.addConstraint(rightConstraint)
                dot.addConstraint(widthConstraint)
                dot.addConstraint(heightConstraint)
            }
            
            return hzy.associatedObject(key: &HzyDotKey,{
                let dot = UIView()
                dot.backgroundColor = BaseColor.red_e1515f
                dot.layer.cornerRadius = 2
                dot.layer.masksToBounds = true
                dot.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(dot)
                setConstraint(dot)
                return dot
            })
        }
    }
    
    var dotColor: UIColor? {
        get {
            return dotView.backgroundColor
        }
        set {
            dotView.backgroundColor = newValue
        }
    }
    
    var dotRight: CGFloat {
        set {
            dotView.superview?.constraints.filter({return $0.identifier == HzyDotConstraintType.right.rawValue}).first?.constant = newValue
        }
        
        get {
            return dotView.superview?.constraints.filter({return $0.identifier == HzyDotConstraintType.right.rawValue}).first?.constant ?? 0
        }
    }
    
    var dotTop: CGFloat {
        set {
            dotView.superview?.constraints.filter({return $0.identifier == HzyDotConstraintType.top.rawValue}).first?.constant = newValue
        }
        
        get {
            return dotView.superview?.constraints.filter({return $0.identifier == HzyDotConstraintType.top.rawValue}).first?.constant ?? 0
        }
    }
    
    
    var dotWidth: CGFloat {
        set {
            dotView.constraints.filter({return $0.identifier == HzyDotConstraintType.width.rawValue}).first?.constant = newValue
        }
        
        get {
            return dotView.constraints.filter({return $0.identifier == HzyDotConstraintType.width.rawValue}).first?.constant ?? 0
        }
    }
    
    var dotHeight: CGFloat {
        set {
            dotView.constraints.filter({return $0.identifier == HzyDotConstraintType.height.rawValue}).first?.constant = newValue
        }
        
        get {
            return dotView.constraints.filter({return $0.identifier == HzyDotConstraintType.height.rawValue}).first?.constant ?? 0
        }
    }
    
    var dotCornerRadius: CGFloat {
        set{
            dotView.layer.cornerRadius = newValue
        }
        get {
            return dotView.layer.cornerRadius
        }
    }
}

extension UIButton: HzyDotable{}

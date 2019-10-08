//
//  ZymeDotable.swift
//  zyme
//
//  Created by zyme on 2018/2/7.
//  Copyright © 2018年 zyme. All rights reserved.
//

import UIKit

private  var _zymeDotKey: UInt8 = 0

private enum ZymeDotConstraintType: String {
    case top = "com.dot.Constraint.top"
    case right = "com.dot.Constraint.right"
    case width = "com.dot.Constraint.minWidth"
    case height = "com.dot.Constraint.height"
}

protocol ZymeDotable {}

extension ZymeDotable where Self: UIView {
    
    var dotView: UIView {
        set {
            zyme.associateSetObject(key: &_zymeDotKey, value: newValue)
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
                
                widthConstraint.identifier = ZymeDotConstraintType.width.rawValue
                heightConstraint.identifier = ZymeDotConstraintType.height.rawValue
                topConstraint.identifier = ZymeDotConstraintType.top.rawValue
                rightConstraint.identifier = ZymeDotConstraintType.right.rawValue
                //添加多个约束
                dot.superview?.addConstraint(topConstraint)
                dot.superview?.addConstraint(rightConstraint)
                dot.addConstraint(widthConstraint)
                dot.addConstraint(heightConstraint)
            }
            
            return zyme.associatedObject(key: &_zymeDotKey,{
                let dot = UIView()
                dot.backgroundColor = self.dotColor ?? UIColor.red
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
            dotView.superview?.constraints.filter({return $0.identifier == ZymeDotConstraintType.right.rawValue}).first?.constant = newValue
        }
        
        get {
            return dotView.superview?.constraints.filter({return $0.identifier == ZymeDotConstraintType.right.rawValue}).first?.constant ?? 0
        }
    }
    
    var dotTop: CGFloat {
        set {
            dotView.superview?.constraints.filter({return $0.identifier == ZymeDotConstraintType.top.rawValue}).first?.constant = newValue
        }
        
        get {
            return dotView.superview?.constraints.filter({return $0.identifier == ZymeDotConstraintType.top.rawValue}).first?.constant ?? 0
        }
    }
    
    
    var dotWidth: CGFloat {
        set {
            dotView.constraints.filter({return $0.identifier == ZymeDotConstraintType.width.rawValue}).first?.constant = newValue
        }
        
        get {
            return dotView.constraints.filter({return $0.identifier == ZymeDotConstraintType.width.rawValue}).first?.constant ?? 0
        }
    }
    
    var dotHeight: CGFloat {
        set {
            dotView.constraints.filter({return $0.identifier == ZymeDotConstraintType.height.rawValue}).first?.constant = newValue
        }
        
        get {
            return dotView.constraints.filter({return $0.identifier == ZymeDotConstraintType.height.rawValue}).first?.constant ?? 0
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

extension UIButton: ZymeDotable{}

//
//  ZymeCustomMaskView.swift
//  DidaSystem
//
//  Created by hzf on 2018/2/26.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import UIKit

class ZymeCustomMaskView: UIView {
    enum MaskType {
        case topCornersAndBottomArc
        case bottomCornersAndTopArc
        case topArc
        case bottomCorners
        case none
        
        var cornersType: RoundingCornersType {
            switch self {
            case .bottomCorners, .bottomCornersAndTopArc: return .bottom
            case .topCornersAndBottomArc: return .top
            default:
                return .none
            }
        }
        
        var arcType: ArcType {
            switch self {
            case .topArc, .bottomCornersAndTopArc: return .top
            case .topCornersAndBottomArc: return .bottom
            default:
                return .none
            }
        }
        
        enum RoundingCornersType {
            case top
            case bottom
            case none
        }
        
        enum ArcType {
            case bottom
            case top
            case none
        }
        
    }
    
    let zymeMask: CAShapeLayer = CAShapeLayer()
    
    var cornerRadii: CGFloat = 5
    
    var maskType: MaskType = .none  {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.mask = zymeMask
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.mask = zymeMask
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        zymeMask.path = getPath().cgPath
    }
    
    
    func getPath() -> UIBezierPath{
        let path = UIBezierPath()
       
        switch maskType.cornersType {
        case .bottom:
            let cornerspath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
            path.append(cornerspath)
            
        case .top:
            let cornerspath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
            path.append(cornerspath)
        default:
            let cornerspath = UIBezierPath(rect: bounds)
            path.append(cornerspath)
        }
      
        switch maskType.arcType {
        case .top:
            let leftPoint = CGPoint(x: 0, y: 0)
            let rightPoint = CGPoint(x: bounds.width, y: 0)
            let leftMaskPath = UIBezierPath(arcCenter: leftPoint, radius: cornerRadii, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi*3/2), clockwise: false)
            
            let rightMaskPath = UIBezierPath(arcCenter: rightPoint, radius: cornerRadii, startAngle: CGFloat(Double.pi*3/2), endAngle: CGFloat(Double.pi/2), clockwise: false)
            path.append(leftMaskPath)
            path.append(rightMaskPath)
            
        case .bottom:
            let leftPoint = CGPoint(x: 0, y: bounds.height)
            let rightPoint = CGPoint(x: bounds.width, y: bounds.height)
            
            let leftMaskPath = UIBezierPath(arcCenter: leftPoint, radius: cornerRadii, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi*3/2), clockwise: false)
            
            let rightMaskPath = UIBezierPath(arcCenter: rightPoint, radius: cornerRadii, startAngle: CGFloat(Double.pi*3/2), endAngle: CGFloat(Double.pi/2), clockwise: false)
            path.append(leftMaskPath)
            path.append(rightMaskPath)
        default:
            break
        }
        
        return path
    }

}

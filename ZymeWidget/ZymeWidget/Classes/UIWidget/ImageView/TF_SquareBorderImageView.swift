//
//  TF_SquareBorderImageView.swift
//  DidaSystem
//
//  Created by hzf on 2017/12/11.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit

class TF_SquareBorderImageView: UIImageView {
    
//    var
   lazy var squareBorder: CAShapeLayer  = {
        let squareBorder = CAShapeLayer()
        squareBorder.strokeColor = UIColor.gray.withAlphaComponent(0.8).cgColor
        squareBorder.fillColor = nil
        squareBorder.lineCap = CAShapeLayerLineCap(rawValue: "square")
        squareBorder.lineDashPattern = [2, 2]
        squareBorder.lineWidth = 1
        self.layer.addSublayer(squareBorder)
        return squareBorder
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        squareBorder.path = UIBezierPath(rect: self.bounds).cgPath
        squareBorder.frame = self.bounds
    }
}


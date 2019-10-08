//
//  ZymeDashLineView.swift
//  DidaSystem
//
//  Created by hzf on 2018/2/28.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import UIKit

class ZymeDashLineView: UIView {
    
    enum lineOrientaionType {
        case horizontal, vertical
    }
    
    var lineOrientation: lineOrientaionType = .vertical
    var lineSpacing: CGFloat = 2
    var lineColor: UIColor = UIColor(hex: "#D2D2DF")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    //MARK: 书线
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineCap(.square)
        context?.setLineDash(phase: 0, lengths: [lineSpacing, lineSpacing])
     
        context?.setStrokeColor(lineColor.cgColor)
        
        context?.beginPath()
        ///水平
        if lineOrientation == .horizontal {
            context?.setLineWidth(self.height)
            context?.move(to: CGPoint(x: 0, y: self.height/2))
            context?.addLine(to: CGPoint(x: self.width, y: self.height/2))

        } else {
            context?.setLineWidth(self.width)
            context?.move(to: CGPoint(x: self.width/2, y: 0))
            context?.addLine(to: CGPoint(x: self.width/2, y: self.height))
        }
        context?.closePath()
        context?.strokePath()
        
    }
}

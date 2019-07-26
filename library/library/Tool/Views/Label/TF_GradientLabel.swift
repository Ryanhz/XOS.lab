//
//  TF_GradientLabel.swift
//  DidaSystem
//
//  Created by hzf on 2017/12/7.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(_ title: String?, fontSize: CGFloat = 17, textColor: UIColor = UIColor.black, textAlignment: NSTextAlignment?){
        self.init()
        self.text = title
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = textColor
        if let alignment = textAlignment {
            self.textAlignment = alignment
        }
    }
}

class TF_GradientLabel: UILabel {

    override open class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.height/2
    }
    
    func config(){
        self.backgroundColor = UIColor.clear
        let gradientlayer = self.layer as! CAGradientLayer
        gradientlayer.colors = [BaseColor.gradient0_3fd4f8.cgColor, BaseColor.gradient1_3fd4f8.cgColor];
        gradientlayer.startPoint = CGPoint(x: 0, y: 0)
        gradientlayer.endPoint = CGPoint(x: 1, y: 0)
        self.layer.masksToBounds = true
        self.textColor = UIColor.white
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      config()
//        gradientlayer.frame = self.bounds
       
    }
}

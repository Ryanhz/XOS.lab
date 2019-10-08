//
//  TF_GradientButton.swift
//  DidaSystem
//
//  Created by hzf on 2017/6/8.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit

//@IBDesignable
class TF_GradientButton: UIButton {
//
   @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setGradient()
        }
    }
    
    var colors: [UIColor]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard self.backgroundImage(for: .normal) == nil else {
            return
        }
        setGradient()
    }
    
    func setGradient(){
        guard self.frame.size != CGSize.zero else {
            return
        }
        
        guard let colors = colors else {
            return;
        }
        
        let backgroundImage = UIImage(gradientLeftToRightColors: colors, size: self.zyme.size, scale: 0)
        self.setBackgroundImage(backgroundImage, for: .normal)
        
    }
}

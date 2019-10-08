//
//  ZymeGradientView.swift
//  DidaSystem
//
//  Created by hzf on 2018/1/17.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import UIKit

@IBDesignable
class ZymeGradientView: UIView {
    
    @IBInspectable var startGradientColor: UIColor = UIColor(rgb: 0x00D2DB){
        didSet{
           config()
        }
    }
    
    @IBInspectable var endGradientColor: UIColor = UIColor(rgb: 0x00D2DB) {
        didSet{
            config()
        }
    }
    
    @IBInspectable var isDrawGradient: Bool = false {
        didSet{
            guard oldValue != isDrawGradient else {
                return
            }
            if isDrawGradient {
                config()
            } else {
               let gradientlayer = self.layer as! CAGradientLayer
                gradientlayer.endPoint = CGPoint(x: 0, y: 0)
            }
        }
    }
    
    override open class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    func config(){
        let gradientlayer = self.layer as! CAGradientLayer
        gradientlayer.colors = [startGradientColor.cgColor, endGradientColor.cgColor];
        gradientlayer.startPoint = CGPoint(x: 0, y: 0)
        gradientlayer.endPoint = CGPoint(x: 1, y: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        config()
    }
}

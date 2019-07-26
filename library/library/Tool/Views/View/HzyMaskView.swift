//
//  HzyMaskView.swift
//  DidaSystem
//
//  Created by hzf on 2018/1/17.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import UIKit
//@IBDesignable
class HzyMaskView: UIView {
    ///曲线的振幅
//    @IBInspectable
    var waveAmplitude: CGFloat = 20 {
        didSet{
            self.layoutIfNeeded()
        }
    }
    ///曲线角速度
    var wavePalstance: CGFloat = CGFloat(Double.pi) / UIScreen.width {
        didSet{
          self.layoutIfNeeded()
        }
    }
    
    ///曲线初相
    var waveX: CGFloat = CGFloat(Double.pi)/4 {
        didSet{
            self.layoutIfNeeded()
        }
    }
    /// 曲线偏距
    var waveY: CGFloat = 20 {
        didSet{
            self.layoutIfNeeded()
        }
    }
    
    var maskLayer: CAShapeLayer = CAShapeLayer()
    
    var isSetMask: Bool = true {
        didSet{
            guard isSetMask != oldValue else {
                return
            }
            self.layoutIfNeeded()
        }
    }
    /*
    
     弦曲线可表示为y=Asin(ωx+φ)+k，定义为函数y=Asin(ωx+φ)+k在直角坐标系上的图象，其中sin为正弦符号，x是直角坐标系x轴上的数值，y是在同一直角坐标系上函数对应的y值，k、ω和φ是常数（k、ω、φ∈R且ω≠0）
     A——振幅，当物体作轨迹符合正弦曲线的直线往复运动时，其值为行程的1/2。
     (ωx+φ)——相位，反映变量y所处的状态。
     φ——初相，x=0时的相位；反映在坐标系上则为图像的左右移动。
     k——偏距，反映在坐标系上则为图像的上移或下移。
     ω——角速度， 控制正弦周期(单位角度内震动的次数)。
    */
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isSetMask {
            updateFrontWaveLayer()
            self.layer.mask = maskLayer
        } else {
            self.layer.mask = nil
        }
    }
    
    fileprivate func updateFrontWaveLayer() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 35))
        for i in 0...Int(UIScreen.width) {
            let x = CGFloat(i)
            let y = waveAmplitude * sin(wavePalstance*x + waveX) + waveY
//            DLog("---------------------y: \(y)")
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: self.width, y: 40))
        path.addLine(to: CGPoint(x: 0, y: 40))
        path.close()
        maskLayer.path = path.cgPath
    
    }
}

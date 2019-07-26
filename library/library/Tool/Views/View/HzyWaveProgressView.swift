//
//  WaveProgressView.swift
//  WaveView
//
//  Created by rayootech on 16/9/1.
//  Copyright © 2016年 demon. All rights reserved.
//

/*
 正弦波浪公式
 
 y=Asin(ωx+φ)+k
 
 A——振幅，当物体作轨迹符合正弦曲线的直线往复运动时，其值为行程的1/2
 ω——角速度， 控制正弦周期(单位角度内震动的次数)
 φ——初相，x=0时的相位；反映在坐标系上则为图像的左右移动
 k——偏距，反映在坐标系上则为图像的上移或下移
 */


import UIKit

class HzyWaveProgressView: UIView {

    /// 前面波纹颜色
    var frontWaveColor: UIColor = UIColor.white.withAlphaComponent(0.4)
    /// 后面波纹颜色
    var behindWaveColor: UIColor = UIColor.white.withAlphaComponent(0.2)
    
    /// 波纹振幅
    var waveAmplitude: CGFloat = 30
    
    ///角速度
    var wavePalstance: CGFloat = CGFloat(Double.pi) / UIScreen.width
    ///曲线初相
    var waveX: CGFloat = 0
    ///曲线偏距
    var waveY: CGFloat = 20
    
    /// 波纹左右偏移速度
    var waveMoveSpeed: CGFloat = CGFloat(Double.pi) / UIScreen.width * 1.6

    fileprivate var frontWaveLayer: CAShapeLayer?
    fileprivate var behindWaveLayer: CAShapeLayer?
    
    fileprivate var displayLink: CADisplayLink?
    
    /// 实时更新振幅，更贴近真实波纹
    fileprivate var waveAmplitudeItem: CGFloat = 5 //1.6
    
    /// 振幅增加还是减少
    fileprivate var increase: Bool = false
    
    //life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - event
    @objc private func startWaveAnimation() {

        updateAmplitude()
        updateFrontWaveLayer()
        updateBehindWaveLayer()
        waveX += waveMoveSpeed
    }
    
    //MARK: - privath methods
    //基本配置
    fileprivate func setUp() {
        clipsToBounds = true
    }
    
    //刷新振幅
    fileprivate func updateAmplitude() {
        if increase {
            waveAmplitudeItem += 0.01
        }else {
            waveAmplitudeItem -= 0.01
        }
        
        if waveAmplitudeItem <= 1 {
            increase = true
        }
        
        if waveAmplitudeItem >= 5 {
            increase = false
        }
        waveAmplitude = waveAmplitudeItem * 5
    }


    //刷新前面的waveLayer
    fileprivate func updateFrontWaveLayer() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: waveY))
        for i in 0...Int(self.width) {
            let x = CGFloat(i)
            let y = waveAmplitude * sin(wavePalstance*x + waveX) + waveY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: self.width, y: self.height))
        path.addLine(to: CGPoint(x: 0, y: self.height))
        path.close()
        frontWaveLayer?.path = path.cgPath
    }
    
    //刷新后面的waveLayer
    fileprivate func updateBehindWaveLayer() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: waveY))
        for i in 0...Int(self.width) {
            let x = CGFloat(i)
            let y = waveAmplitude * cos(wavePalstance*x + waveX) + waveY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: self.width, y: self.height))
        path.addLine(to: CGPoint(x: 0, y: self.height))
        path.close()
        behindWaveLayer?.path = path.cgPath
    }
   
    
    //MARK: - public methods
    /**
     开始波动
     */
    func startWave() {
        if behindWaveLayer == nil {
            behindWaveLayer = CAShapeLayer()
            behindWaveLayer?.fillColor = behindWaveColor.cgColor
            layer.addSublayer(behindWaveLayer!)
        }
        if frontWaveLayer == nil {
            frontWaveLayer = CAShapeLayer()
            frontWaveLayer?.fillColor = frontWaveColor.cgColor
            layer.addSublayer(frontWaveLayer!)
        }
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(startWaveAnimation))
            displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        }
    }
    /**
     停止波动
     */
    func stopWave() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
}

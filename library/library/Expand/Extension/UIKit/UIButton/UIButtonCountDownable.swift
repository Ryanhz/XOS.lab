//
//  UIButtonCountDownable.swift
//  DidaSystem
//
//  Created by hzf on 2018/3/14.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import Foundation
import UIKit

protocol UIButtonCountDownable {}

extension UIButtonCountDownable where Self: UIButton {
    func startWithTime(maxTime: Int, title: String, countDownUnit:String, bgColor: UIColor, runBgColor: UIColor) {
        var timeOut = maxTime
        let queue = DispatchQueue.hzy.default
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        timer.schedule(deadline: .now(), repeating: DispatchTimeInterval.seconds(1), leeway: .milliseconds(20))
        timer.setEventHandler {
            //倒计时结束，关闭
            if timeOut <= 0 {
                timer.cancel()
                DispatchQueue.main.async {
                    self.backgroundColor = bgColor
                    self.setTitle(title, for: .normal)
                    self.isUserInteractionEnabled = true
                }
            } else {
                let allTime = timeOut + 1
                let seconds = timeOut % allTime
                let timeStr = String(format: "%0.2d", seconds)
                DispatchQueue.main.async {
                    self.backgroundColor = runBgColor
                    self.setTitle("\(timeStr)\(countDownUnit)", for: .normal)
                    self.isUserInteractionEnabled = false
                }
                timeOut -= 1
            }
        }
        timer.resume()
    }
}

extension UIButton: UIButtonCountDownable{}

extension HzyNamespaceWrapper where T: UIButton {
    func startWithTime(maxTime: Int, title: String, countDownUnit:String, bgColor: UIColor, runBgColor: UIColor) {
        wrappedValue.startWithTime(maxTime: maxTime, title: title, countDownUnit: countDownUnit, bgColor: bgColor, runBgColor: bgColor)
    }
}




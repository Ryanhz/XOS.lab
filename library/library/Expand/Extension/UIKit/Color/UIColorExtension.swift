//
//  UIColorExtension.swift
//  FETools
//
//  Created by hzf on 2017/11/1.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit

//extension UIColor: HzyNamespaceWrappable {}

extension HzyNamespaceWrapper where T: UIColor {
 
    public static func color(hex: String) ->UIColor {
        let defaultColor = UIColor.clear
        var hexColorText = hex.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        switch hexColorText {
        case let text where text.hasPrefix("0x"):
            hexColorText = text.hzy.substring(from: 2)
        case let text where text.hasPrefix("#"):
            hexColorText = text.hzy.substring(from: 1)
        default:
            break
        }
        if hexColorText.count == 8 {
            return alphaHexColor(text: hexColorText, defaultColor: defaultColor)
        } else {
           return hexColor(text: hexColorText, defaultColor: defaultColor)
        }
    }
    
    public static func color(rgb: UInt) ->UIColor {
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((rgb & 0xFF)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    public static func color(argb: UInt) ->UIColor {
        let alpha = CGFloat((argb & 0xFF000000) >> 24) / 255
        let red   = CGFloat((argb & 0xFF0000) >> 16) / 255
        let green = CGFloat((argb & 0xFF00) >> 8) / 255
        let blue  = CGFloat((argb & 0xFF)) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public static func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256)) / 255
        let g = CGFloat(arc4random_uniform(256)) / 255
        let b = CGFloat(arc4random_uniform(256)) / 255
        let a = CGFloat(arc4random_uniform(256)) / 255
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    private static func hexColor(text: String, defaultColor: UIColor = UIColor.clear) -> UIColor {
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        guard Scanner(string: text.hzy.substring(with: 0..<2)).scanHexInt32(&r),
            Scanner(string: text.hzy.substring(with: 2..<4)).scanHexInt32(&g),
            Scanner(string: text.hzy.substring(with: 4..<6)).scanHexInt32(&b)
            else {
                return defaultColor
        }
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
    }
    
    private static func alphaHexColor(text: String, defaultColor: UIColor = UIColor.clear) -> UIColor {
        let alphaString = text.hzy.substring(with: 0..<2)
        let redString = text.hzy.substring(with: 2..<4)
        let greenString = text.hzy.substring(with: 4..<6)
        let blueString = text.hzy.substring(with: 6..<8)
        
        var r: UInt32 = 0x0, g: UInt32 = 0x0, b: UInt32 = 0x0, a: UInt32 = 0x0
        guard Scanner(string: alphaString).scanHexInt32(&a),
            Scanner(string:redString).scanHexInt32(&r),
            Scanner(string:greenString).scanHexInt32(&g),
            Scanner(string: blueString).scanHexInt32(&b)
            else {
                return defaultColor
        }
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
    }
}


extension UIColor {
    
    convenience init(hex: String) {
        self.init(cgColor: UIColor.hzy.color(hex: hex).cgColor)
    }
    
    // MARK: -<##>
    convenience init(rgb: UInt) {
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgb & 0xFF00) >> 8) / 255
        let blue = CGFloat((rgb & 0xFF)) / 255
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    convenience init(rgba: UInt) {
        let alpha     = CGFloat((rgba & 0xFF000000) >> 24) / 255
        let red   = CGFloat((rgba & 0xFF0000) >> 16) / 255
        let green    = CGFloat((rgba & 0xFF00) >> 8) / 255
        let blue   = CGFloat((rgba & 0xFF)) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class func randomColor() ->Self{
        let r = CGFloat(arc4random_uniform(256)) / 255
        let g = CGFloat(arc4random_uniform(256)) / 255
        let b = CGFloat(arc4random_uniform(256)) / 255
        
        return self.init(red: r, green: g, blue: b, alpha: 1)
    }
}

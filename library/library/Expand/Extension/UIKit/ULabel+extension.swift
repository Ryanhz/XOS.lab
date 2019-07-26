//
//  ULabel+extension.swift
//  Hzy
//
//  Created by hzf on 2017/10/23.
//  Copyright © 2017年 Hzy. All rights reserved.
//

import UIKit

extension HzyNamespaceWrapper where T: UILabel {
    
    func set(fontSize: CGFloat?, textColor: UIColor?) {
        
        if let fontSize = fontSize {
            set(font: UIFont.systemFont(ofSize: fontSize), textColor: nil)
        }
        
        if let textColor = textColor {
            set(font: nil, textColor: textColor)
        }
    }
    
    func set(font: UIFont?, textColor: UIColor?) {
        
        if let font = font {
            wrappedValue.font = font
        }
        
        if let textColor = textColor {
            wrappedValue.textColor = textColor
        }
    }
}



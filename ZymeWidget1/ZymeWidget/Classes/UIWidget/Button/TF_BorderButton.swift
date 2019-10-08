//
//  TF_BorderButton.swift
//  DidaSystem
//
//  Created by hzf on 2018/1/2.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import UIKit

//@IBDesignable
class TF_BorderButton: UIButton {

    //
  @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    //@IBInspectable
     @IBInspectable var borderColor: UIColor = UIColor() {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    //@IBInspectable
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
}

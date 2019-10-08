//
//  TF_leftImageBtn.swift
//  DidaSystem
//
//  Created by hzf on 2017/6/16.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit

class TF_leftImageBtn: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let Offset: CGFloat = (imageView?.width)!
        var center = superview == nil ? self.center : superview!.convert(self.center, to: self)
        center.x -= 5
        
        titleLabel?.frame = CGRect(x: 0, y: 0, width: (titleLabel?.width)!, height: (titleLabel?.height)!)
        titleLabel?.textAlignment = .center
        titleLabel?.center = center
        
        imageView?.frame = CGRect(x: (titleLabel?.frame)!.maxX+5, y: (titleLabel?.frame)!.minY, width: Offset, height: (imageView?.height)!)
        imageView?.center.y = titleLabel!.centerY
        imageView?.contentMode = UIView.ContentMode.center
    }
}

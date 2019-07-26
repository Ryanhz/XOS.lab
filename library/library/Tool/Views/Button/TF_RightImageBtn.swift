//
//  TF_RightImageBtn.swift
//  DidaSystem
//
//  Created by hzf on 2017/6/16.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit

class TF_RightImageBtn: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageView =  self.imageView, let titleLabel = self.titleLabel else {
            return
        }
        
        let imageWidth = imageView.width
        let titleLabelWidth = titleLabel.width
        
        let space: CGFloat = 5
        
        let contentWidth = imageWidth + titleLabelWidth + space
        
        var titleLabelX = (self.width - contentWidth)/2
        titleLabelX = (titleLabelX < 0 ? 0 : titleLabelX)
        
        titleLabel.frame = CGRect(x: titleLabelX, y: titleLabel.y, width: titleLabelWidth, height: titleLabel.height)
        
        imageView.frame = CGRect(x: titleLabel.frame.maxX + space, y: imageView.y, width: imageWidth, height: imageView.height)
    }
}

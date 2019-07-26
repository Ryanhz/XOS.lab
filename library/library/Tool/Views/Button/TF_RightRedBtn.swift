//
//  TF_RightRedBtn.swift
//  DidaSystem
//
//  Created by hzf on 2017/7/10.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit

class TF_RightRedBtn: UIButton {
 
    var dotView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dotView = UIView()
        dotView.backgroundColor = UIColor.red
        dotView.bounds = CGRect(x: 0, y: 0, width: 6, height: 6)
        dotView.layer.cornerRadius = 3
        dotView.layer.masksToBounds = true
        self.addSubview(dotView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let Offset: CGFloat = dotView.width
//        var center = superview == nil ? self.center : superview!.convert(self.center, to: self)
//        center.x -= 5
        imageView?.x -= 5
        
//        titleLabel?.frame = CGRect(x: 0, y: 0, width: (titleLabel?.width)!, height: (titleLabel?.height)!)
//        titleLabel?.textAlignment = .center
//        titleLabel?.center = center
        
        dotView?.frame = CGRect(x: (titleLabel?.frame)!.maxX+5, y: (titleLabel?.frame)!.minY, width: Offset, height: dotView.height)
        dotView?.center.y = titleLabel!.centerY
    }
}

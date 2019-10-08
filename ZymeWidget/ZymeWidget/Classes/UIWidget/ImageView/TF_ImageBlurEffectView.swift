//
//  TF_ImageBlurEffectView.swift
//  DidaSystem
//
//  Created by hzf on 2017/12/8.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit

///透明遮罩的的imageView
class TF_ImageBlurEffectView: UIImageView {
    
   private var effectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    var blurStyle: UIBlurEffect.Style = .dark {
        didSet{
            guard blurStyle != oldValue else {
                return
            }
            let blurEffect = UIBlurEffect(style: blurStyle)
            effectView.effect = blurEffect
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       setupSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        effectView.frame = self.bounds
    }
    
    func setupSubviews() {
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
//        let effect = UIBlurEffect(style: .dark)
//        effectView = UIVisualEffectView(effect: effect)
        self.addSubview(effectView)
    }
}

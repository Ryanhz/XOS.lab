//
//  HzyTextCarouselView.swift
//  library
//
//  Created by hzf on 2018/9/11.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit

class HzyTextCarouselView: UIView {
    
    enum CarouselDirection {
        case horizontal
        case vertical
    }
    
    var autoTimeInterval: TimeInterval = 2
    
    let contentView: UIView = UIView()
    
    let placeHolderView: UIView = UIView()
    
    let placeHolderView2: UIView = UIView()
    
    var timer: Timer?
    
    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = self.bounds
        placeHolderView2.frame.size = contentView.frame.size
        placeHolderView.frame.size = contentView.frame.size
        reset()
    }
    
    func setupSubviews() {
        contentView.addSubview(placeHolderView)
        contentView.addSubview(placeHolderView2)
        self.addSubview(contentView)
    }
    
    func reset() {
        placeHolderView.frame.origin = .init(x: 0, y: 0)
        placeHolderView2.frame.origin = .init(x: 0, y: placeHolderView.height)
    }
    
    
    
    
}

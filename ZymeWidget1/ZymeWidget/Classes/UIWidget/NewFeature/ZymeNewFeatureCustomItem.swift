//
//  ZymeNewFeatureItemViewController.swift
//  library
//
//  Created by Ranger on 2018/5/14.
//  Copyright © 2018年 zyme. All rights reserved.
//

import UIKit

public class ZymeNewFeatureCustomItem: UIView, NewFeaturSubViewItemable{
    
    private var isShowEnterBtn: Bool = false
    
    private var imageName: String = ""
    
    var completeBlock: (()->Void)?
    
    public var newFeatureView: UIView {
        return self
    }
    
   lazy var imageView: UIImageView = {
        return UIImageView(image: UIImage(named: imageName))
    }()
    
    lazy var enterBtn: UIButton = {
        let button = UIButton()
        button.setTitle("进入", for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(ZymeNewFeatureCustomItem.enterClickAction), for: .touchUpInside)
        self.addSubview(button)
        button.snp.makeConstraints({[unowned self] (maker) in
            maker.width.equalTo(120)
            maker.height.equalTo(30)
            maker.bottom.equalTo(-80)
            maker.centerX.equalTo(self)
        })
        return button
    }()
    
    public class func items(imageNames: String...)->[ZymeNewFeatureCustomItem]{
        var items: [ZymeNewFeatureCustomItem] = []
        for (index, imageName) in imageNames.enumerated() {
            let itemVC = ZymeNewFeatureCustomItem(image: imageName, isShowEnterBtn: index == imageNames.count - 1)
            items.append(itemVC)
        }
        return items
    }
    
  convenience init(image: String, isShowEnterBtn: Bool = false) {
        self.init(frame: .zero)
        self.isShowEnterBtn = isShowEnterBtn
        self.imageName = image
        setupSubViews()
    }
 
   private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setCompleteBlock(block: @escaping () -> Void) {
        completeBlock = block
    }
    
    public func zymeDidEnterForeground() {
        UIView.animate(withDuration: 0.5) {
            self.imageView.transform = CGAffineTransform.identity
        }
    }
    
    public func zymeDidEnterBackGround() {
        UIView.animate(withDuration: 0.5) {
            self.imageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }
    }
    
    @objc func enterClickAction(_ sender: Any) {
        completeBlock?()
    }
    
    func setupSubViews(){
        self.layer.masksToBounds = true
        imageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        self.addSubview(imageView)
        imageView.snp.makeConstraints({ (maker) in
            maker.edges.equalTo(self)
        })
        if self.isShowEnterBtn {
            self.enterBtn.isHidden = false;
        }
    }
    
}

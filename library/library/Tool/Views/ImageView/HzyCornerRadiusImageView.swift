//
//  HzyCornerRadiusImageView.swift
//  library
//
//  Created by Ranger on 2018/5/3.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit

class HzyCornerRadiusImageView: UIImageView {
    
    deinit {
        DLog("000")
    }
    var originImage: UIImage?
    var cornerRadius: CGFloat = 0 {
        didSet{
            guard cornerRadius != oldValue else {
                return
            }
            updateImageView()
        }
    }
    
    override var image: UIImage? {
        didSet {
            guard let image = image, image != oldValue, !image.hzy.hzyCornerRadius else {
                return
            }
            updateImageView()
        }
    }
    
    override var contentMode: UIView.ContentMode {
        didSet {
            
            guard contentMode != oldValue else {
                return
            }
            updateImageView()
        }
    }
    
    func updateImageView(){
        guard let originImage = self.image, cornerRadius > 0 else {
            return
        }
        self.originImage = originImage
        var image: UIImage?
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        if let currnetContext = UIGraphicsGetCurrentContext() {
            let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius).cgPath
            currnetContext.addPath(path)
            currnetContext.clip()
            self.layer.render(in: currnetContext)
            
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        if let image = image {
            image.hzy.hzyCornerRadius = true
            self.image = image
        } else {
            DispatchQueue.main.async {
                self.updateImageView()
            }
        }
    }
}

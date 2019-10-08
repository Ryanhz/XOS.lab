//
//  ZymeCornerRadiusImageView.swift
//  library
//
//  Created by Ranger on 2018/5/3.
//  Copyright © 2018年 zyme. All rights reserved.
//

import UIKit

class ZymeCornerRadiusImageView: UIImageView {
    
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
            guard let image = image, image != oldValue, !image.zyme.zymeCornerRadius else {
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
            image.zyme.zymeCornerRadius = true
            self.image = image
        } else {
            DispatchQueue.main.async {
                self.updateImageView()
            }
        }
    }
}

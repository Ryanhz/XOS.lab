//
//  UIImageViewCornerRadius.swift
//  zyme
//
//  Created by zyme on 2018/3/14.
//  Copyright © 2018年 zyme. All rights reserved.
//

import Foundation
import UIKit

fileprivate var ZymeCornerRadiusKey: UInt8 = 0
fileprivate var ZymeimageObserverKey: UInt8 = 0

protocol ZymeCornerRadiusable {}

extension ZymeNamespaceWrapper where T: UIImage {
    
    var zymeCornerRadius: Bool {
        get{
            return associatedObject(key: &ZymeCornerRadiusKey) { () -> Bool in
                return false
            }
        }
        set{
            associateSetObject(key: &ZymeCornerRadiusKey, value: newValue)
        }
    }
}

class ZymeImageObserver: NSObject {
    
   fileprivate weak var originImageView: UIImageView?
    
   fileprivate weak var originImage: UIImage?
    
   fileprivate var cornerRadius: CGFloat = 0 {
        didSet {
            guard cornerRadius != oldValue , cornerRadius > 0 else {
                return
            }
            updateImageView()
        }
    }
    
    deinit {
        self.originImageView?.removeObserver(self, forKeyPath: "image")
        self.originImageView?.removeObserver(self, forKeyPath: "contentMode")
    }
    
    init(imageView: UIImageView) {
        self.originImageView = imageView
        super.init()
        imageView.addObserver(self, forKeyPath: "image", options: .new, context: nil)
        imageView.addObserver(self, forKeyPath: "contentMode", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "image", let newImage = change?[.newKey] as? UIImage, !newImage.zyme.zymeCornerRadius {
            updateImageView()
        }
        if keyPath == "contentMode" {
            self.originImageView?.image = self.originImage;
        }
    }
    
    func updateImageView(){
        guard let originImage = self.originImageView?.image else {
            return
        }
        
        self.originImage = originImage
        var image: UIImage?
        
        UIGraphicsBeginImageContextWithOptions(originImageView!.bounds.size, false, UIScreen.main.scale)
        
        if let currnetContext = UIGraphicsGetCurrentContext() {
            let path = UIBezierPath(roundedRect: originImageView!.bounds, cornerRadius: self.cornerRadius).cgPath
            currnetContext.addPath(path)
            currnetContext.clip()
            originImageView!.layer.render(in: currnetContext)
            
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        if let image = image {
            image.zyme.zymeCornerRadius = true
            originImageView!.image = image
        } else {
            DispatchQueue.main.async {
                self.updateImageView()
            }
        }
    }
}


extension ZymeNamespaceWrapper where T: UIImageView, T: ZymeCornerRadiusable {

   private var imageObserver: ZymeImageObserver {
        return associatedObject(key: &ZymeimageObserverKey, {
            ZymeImageObserver(imageView: self.wrappedValue)
        })
    }

    var aliCornerRadius: CGFloat {
        set {
            
//            wrappedValue.layer.cornerRadius = newValue
//            wrappedValue.layer.masksToBounds = true
            imageObserver.cornerRadius = newValue
        }
        get {
            return imageObserver.cornerRadius
           // return wrappedValue.layer.cornerRadius //imageObserver.cornerRadius
        }
    }
}

extension ZymeCornerRadiusable where Self: UIImageView  {
    
}







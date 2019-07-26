//
//  UIImageViewCornerRadius.swift
//  DidaSystem
//
//  Created by hzf on 2018/3/14.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import Foundation
import UIKit

fileprivate var HzyCornerRadiusKey: UInt8 = 0
fileprivate var HzyimageObserverKey: UInt8 = 0

protocol HzyCornerRadiusable {}

extension HzyNamespaceWrapper where T: UIImage {
    
    var hzyCornerRadius: Bool {
        get{
            return associatedObject(key: &HzyCornerRadiusKey) { () -> Bool in
                return false
            }
        }
        set{
            associateSetObject(key: &HzyCornerRadiusKey, value: newValue)
        }
    }
}

class HzyImageObserver: NSObject {
    
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
        DLog("release")
        DLog(originImageView)
        
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
        if keyPath == "image", let newImage = change?[.newKey] as? UIImage, !newImage.hzy.hzyCornerRadius {
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
            image.hzy.hzyCornerRadius = true
            originImageView!.image = image
        } else {
            DispatchQueue.main.async {
                self.updateImageView()
            }
        }
    }
}


extension HzyNamespaceWrapper where T: UIImageView, T: HzyCornerRadiusable {

   private var imageObserver: HzyImageObserver {
        return associatedObject(key: &HzyimageObserverKey, {
            HzyImageObserver(imageView: self.wrappedValue)
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

extension HzyCornerRadiusable where Self: UIImageView  {
    
}







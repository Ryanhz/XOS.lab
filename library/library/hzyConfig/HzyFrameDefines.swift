//
//  HzyFrameDefines.swift
//  Hzy
//
//  Created by hzf on 2017/5/10.
//  Copyright © 2017年 Hzy. All rights reserved.
//

import UIKit

class SizeHelper {
    /// 设计的参照尺寸
    static let design_deviceSize = CGSize(width: 375, height: 667)
    
    /// 根据设计的宽度返回在本设备上等比例的宽度
    ///
    /// - Parameter design_Width: 设计的宽度
    /// - Returns: 本设备上实际的宽度
    class func width(design_Width: CGFloat) ->CGFloat {
        return (design_Width * UIScreen.hzy.width) / design_deviceSize.width
    }
    
    /// 根据设计宽度返回在本设备上等比例的高度
    ///
    /// - Parameter design_height: 根据设计的高度  返回在本设备上实际的高度
    /// - Returns: 本设备上实际的高度
    class func height(design_height: CGFloat ) -> CGFloat {
        
        return (design_height * UIScreen.hzy.height) / design_deviceSize.height
    }
    
    class func length(design_length: CGFloat, ratio: CGFloat)->CGFloat{
        return ratio * design_length
    }
    
    class func ratioHeight(design_Height: CGFloat)-> CGFloat{
        return length(design_length: design_Height, ratio: UIScreen.hzy.width/design_deviceSize.width)
    }
    
    class func ratioWidth(design_width: CGFloat)-> CGFloat {
        // w/dw = mySc/deSize
        return length(design_length: design_width, ratio: UIScreen.hzy.height/design_deviceSize.height)
    }
    
}

class ImageHelper {

    class func gradientLeftToRight(imageSize: CGSize)->UIImage?{
        
        guard imageSize.height != 0, imageSize.width != 0 else {
            return nil
        }
        let colors = [UIColor.hzy.color(rgb: 0x3FD4F8), UIColor.hzy.color(rgb: 0x715AE8)]
        
        return gradientLeftToRight(imageSize: imageSize, colors: colors)
    }

    class func gradientLeftToRight(imageSize: CGSize, colors: [UIColor])->UIImage?{
        
        guard imageSize.height != 0, imageSize.width != 0 else {
            return nil
        }
        return UIImage(gradientLeftToRightColors: colors, size: imageSize, scale: 0)
    }
    
    class func gradientImage(imageSize: CGSize)->UIImage?{
        let colors = [UIColor.hzy.color(rgb: 0x1195db), UIColor.hzy.color(rgb: 0x364eed)]
        return gradientImage(imageSize: imageSize, colors: colors)
    }
    
    class func gradientImage(imageSize: CGSize, colors: [UIColor])->UIImage?{
        
        guard imageSize.height != 0, imageSize.width != 0 else {
            return nil
        }
        let headBGImg = UIImage(gradientColors: colors, size: imageSize)
        return headBGImg
    }
    
}
extension UIImage{
    public func roundImage(byRoundingCorners: UIRectCorner = UIRectCorner.allCorners, cornerRadii: CGSize) -> UIImage? {
        
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        guard context != nil else {
            return nil
        }
        context?.setShouldAntialias(true)
        let bezierPath = UIBezierPath(roundedRect: imageRect,
                                      byRoundingCorners: byRoundingCorners,
                                      cornerRadii: cornerRadii)
        bezierPath.close()
        bezierPath.addClip()
        self.draw(in: imageRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}



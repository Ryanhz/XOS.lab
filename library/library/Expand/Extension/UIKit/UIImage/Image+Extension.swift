//
//  ImageExtension.swift
//  TableClient
//
//  Created by hzf on 16/9/26.
//  Copyright © 2016年 MY. All rights reserved.
//


import Foundation
import UIKit
import QuartzCore
import CoreGraphics
import Accelerate


public enum UIImageContentMode {
    case scaleToFill, scaleAspectFit, scaleAspectFill
}

public extension UIImage {
    
    class func createImageFromView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.bounds.size);
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return image!
    }
    
    func compressImage(_ cropSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContext(cropSize)
        self.draw(in: CGRect(x: 0, y: 0, width: cropSize.width, height: cropSize.height))
        let compressedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return compressedImg!
    }
    
    func imageCompressForSize(_ targetSize: CGSize)-> UIImage?{
        
        var newImage: UIImage?
        let imageSize = self.size
        
        var scaleFactor: CGFloat = 0
        var scaledWidth = targetSize.width
        var scaledHeight = targetSize.height
        var thumbnailPoint = CGPoint.zero
        
        if imageSize != targetSize {
            let widthFactor = targetSize.width / imageSize.width
            let heightFactor = targetSize.height / imageSize.height
            if widthFactor > heightFactor{
                scaleFactor = widthFactor
            } else {
                scaleFactor = heightFactor
            }
            scaledWidth = imageSize.width * scaleFactor
            scaledHeight = imageSize.height * scaleFactor
            
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetSize.height - scaledHeight) * 0.5
            } else if widthFactor < heightFactor {
                thumbnailPoint.x = (targetSize.width - scaledWidth) * 0.5
            }
            
        }
        
//        UIGraphicsBeginImageContext(targetSize)
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        self.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // MARK: 纯色
    /**
     生成纯色图片
     */
    convenience init?(color:UIColor, size:CGSize = CGSize(width: 10, height: 10))
    {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }
    
    // MARK:  渐变色（上到下）
    
    convenience init?(gradientColors:[UIColor], size:CGSize = CGSize(width: 10, height: 10) )
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map {(color: UIColor) -> AnyObject? in return color.cgColor } as NSArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)
        
        context?.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: CGGradientDrawingOptions(rawValue: 0))
        
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage)!)
        UIGraphicsEndImageContext()
    }
    
    //// MARK:  渐变色（左到右）scale default is 1
    convenience init?(gradientLeftToRightColors:[UIColor], size:CGSize = CGSize(width: 10, height: 10), scale:CGFloat = 1  )
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientLeftToRightColors.map {(color: UIColor) -> AnyObject? in return color.cgColor } as NSArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)
        
        context?.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: 0), options: CGGradientDrawingOptions(rawValue: 0))
        
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage)!)
        UIGraphicsEndImageContext()
    }
    
    // MARK:  添加覆盖层
    func applyGradientColors(_ gradientColors: [UIColor], blendMode: CGBlendMode = CGBlendMode.normal) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(blendMode)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context?.draw(self.cgImage!, in: rect)
        // Create gradient
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map {(color: UIColor) -> AnyObject? in return color.cgColor } as NSArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)
        // Apply gradient
        context?.clip(to: rect, mask: self.cgImage!)
        context?.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: CGGradientDrawingOptions(rawValue: 0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image!;
    }
    
    // MARK: 根据文字生成图片
    /**
     - Parameter text: The text to use in the label.
     - Parameter font: 默认18
     - Parameter color: 默认白色
     - Parameter backgroundColor: 默认灰色
     - Parameter size: Image size 默认10*10
     - Parameter offset: Center offset 默认0*0
     
     */
    convenience init?(text: String, font: UIFont = UIFont.systemFont(ofSize: 18), color: UIColor = UIColor.white, backgroundColor: UIColor = UIColor.gray, size:CGSize = CGSize(width: 100, height: 100), offset: CGPoint = CGPoint(x: 0, y: 0))
    {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.font = font
        label.text = text
        label.textColor = color
        label.textAlignment = .center
        label.backgroundColor = backgroundColor
        let image = UIImage(fromView: label)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }
    
    // MARK: 通过View生成图片

    convenience init?(fromView view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        //view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }
    
    // MARK:  从中间辐射
    // 参考: http://developer.apple.com/library/ios/#documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_shadings/dq_shadings.html
    
    
    // MARK: Alpha
    
    func hasAlpha() -> Bool
    {
        let alpha = self.cgImage?.alphaInfo
        switch (alpha)! {
        case .first, .last, .premultipliedFirst, .premultipliedLast:
            return true
        default:
            return false
            
        }
    }
    
    // MARK: 为没有alpha的图片添加alpha层
    /**
     Returns a copy of the given image, adding an alpha channel if it doesn't already have one.
     */
//    func applyAlpha() -> UIImage?
//    {
//        if hasAlpha() {
//            return self
//        }
//        
//        let imageRef = self.cgImage
//        let width = imageRef?.width
//        let height = imageRef?.height
//        let colorSpace = imageRef?.colorSpace
//        
//        // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
//        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
//        let offscreenContext = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue)
//        
//        // Draw the image into the context and retrieve the new image, which will now have an alpha layer
//        offscreenContext?.draw(imageRef, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height!)))
//        let imageWithAlpha = UIImage(cgImage: offscreenContext?.makeImage()!)
//        return imageWithAlpha
//    }
    
    /**
     Returns a copy of the image with a transparent border of the given size added around its edges. i.e. For rotating an image without getting jagged edges.
     
     - Parameter padding: The padding amount.
     
     - Returns A new image.
     */
//    func applyPadding(_ padding: CGFloat) -> UIImage?
//    {
//        // If the image does not have an alpha layer, add one
//        let image = self.applyAlpha()
//        if image == nil {
//            return nil
//        }
//        let rect = CGRect(x: 0, y: 0, width: size.width + padding * 2, height: size.height + padding * 2)
//        
//        // Build a context that's the same dimensions as the new size
//        let colorSpace = self.cgImage?.colorSpace
//        let bitmapInfo = self.cgImage?.bitmapInfo
//        let bitsPerComponent = self.cgImage?.bitsPerComponent
//        let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: bitsPerComponent!, bytesPerRow: 0, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)
//        
//        // Draw the image in the center of the context, leaving a gap around the edges
//        let imageLocation = CGRect(x: padding, y: padding, width: image!.size.width, height: image!.size.height)
//        context?.draw(self.cgImage, in: imageLocation)
//        
//        // Create a mask to make the border transparent, and combine it with the image
//        let transparentImage = UIImage(cgImage: context?.makeImage().masking(imageRefWithPadding(padding, size: rect.size))!)
//        return transparentImage
//    }
    
    /**
     Creates a mask that makes the outer edges transparent and everything else opaque. The size must include the entire mask (opaque part + transparent border).
     
     - Parameter padding: The padding amount.
     - Parameter size: The size of the image.
     
     - Returns A Core Graphics Image Ref
     */
    fileprivate func imageRefWithPadding(_ padding: CGFloat, size:CGSize) -> CGImage
    {
        // Build a context that's the same dimensions as the new size
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        // Start with a mask that's entirely transparent
        context?.setFillColor(UIColor.black.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // Make the inner part (within the border) opaque
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(CGRect(x: padding, y: padding, width: size.width - padding * 2, height: size.height - padding * 2))
        // Get an image of the context
        let maskImageRef = context?.makeImage()
        return maskImageRef!
    }
    
    
    // MARK: 区域内裁剪
    
    func crop(_ bounds: CGRect) -> UIImage?
    {
        return UIImage(cgImage: (self.cgImage?.cropping(to: bounds)!)!,
                       scale: 0.0, orientation: self.imageOrientation)
    }
    
    func cropToSquare() -> UIImage? {
        let size = CGSize(width: self.size.width * self.scale, height: self.size.height * self.scale)
        let shortest = min(size.width, size.height)
        let left: CGFloat = size.width > shortest ? (size.width-shortest)/2 : 0
        let top: CGFloat = size.height > shortest ? (size.height-shortest)/2 : 0
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let insetRect = rect.insetBy(dx: left, dy: top)
        return crop(insetRect)
    }
    
    // MARK: Resize
    
    /**
     Creates a resized copy of an image.
     
     - Parameter size: The new size of the image.
     - Parameter contentMode: The way to handle the content in the new size.
     
     - Returns A new image
     */
    func resize(_ size:CGSize, contentMode: UIImageContentMode = .scaleToFill) -> UIImage?
    {
        let horizontalRatio = size.width / self.size.width;
        let verticalRatio = size.height / self.size.height;
        var ratio: CGFloat!
        
        switch contentMode {
        case .scaleToFill:
            ratio = 1
        case .scaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
        case .scaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width * ratio, height: size.height * ratio)
        
        // Fix for a colorspace / transparency issue that affects some types of
        // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951
    
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
      
        let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        let transform = CGAffineTransform.identity
        
        // Rotate and/or flip the image if required by its orientation
        context?.concatenate(transform);
        
        // Set the quality level to use when rescaling
        context!.interpolationQuality =  .high//CGInterpolationQuality(rawValue: 3)!
        
        // Draw into the context; this scales the image
        context?.draw(self.cgImage!, in: rect)
        
        // Get the resized image from the context and a UIImage
        let newImage = UIImage(cgImage: (context?.makeImage()!)!, scale: self.scale, orientation: self.imageOrientation)
        return newImage;
    }
    
    
    
    
//    // MARK:  处理圆角
//    
//    func roundCorners(_ cornerRadius:CGFloat) -> UIImage?
//    {
//        // If the image does not have an alpha layer, add one
//        let imageWithAlpha = applyAlpha()
//        if imageWithAlpha == nil {
//            return nil
//        }
//        
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        let width = imageWithAlpha?.cgImage?.width
//        let height = imageWithAlpha?.cgImage?.height
//        let bits = imageWithAlpha?.cgImage?.bitsPerComponent
//        let colorSpace = imageWithAlpha?.cgImage?.colorSpace
//        let bitmapInfo = imageWithAlpha?.cgImage?.bitmapInfo
//        let context = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: bits!, bytesPerRow: 0, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)
//        let rect = CGRect(x: 0, y: 0, width: CGFloat(width!)*scale, height: CGFloat(height!)*scale)
//        
//        context?.beginPath()
//        if (cornerRadius == 0) {
//            context?.addRect(rect)
//        } else {
//            context?.saveGState()
//            context?.translateBy(x: rect.minX, y: rect.minY)
//            context?.scaleBy(x: cornerRadius, y: cornerRadius)
//            let fw = rect.size.width / cornerRadius
//            let fh = rect.size.height / cornerRadius
//            context?.move(to: CGPoint(x: fw, y: fh/2))
//            
//            CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1)
//            
//            
//            CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1)
//            CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1)
//            CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1)
//            context.restoreGState()
//        }
//        context.closePath()
//        CGContextClip(context)
//        
//        context.draw(imageWithAlpha?.cgImage, in: rect)
//        let image = UIImage(cgImage: context.makeImage()!, scale:scale, orientation: .up)
//        UIGraphicsEndImageContext()
//        return image
//    }
    
    // MARK: 圆角和阴影
    
//    func roundCorners(_ cornerRadius:CGFloat, border:CGFloat, color:UIColor) -> UIImage?
//    {
//        return roundCorners(cornerRadius)?.applyBorder(border, color: color)
//    }
    
    // MARK: 圆形图片
    
//    func roundCornersToCircle() -> UIImage?
//    {
//        let shortest = min(size.width, size.height)
//        return cropToSquare()?.roundCorners(shortest/2)
//    }
    
    // MARK: 圆形图片加阴影
//    func roundCornersToCircle(border:CGFloat, color:UIColor) -> UIImage?
//    {
//        let shortest = min(size.width, size.height)
//        return cropToSquare()?.roundCorners(shortest/2, border: border, color: color)
//    }
//    
    // MARK: 添加阴影
    
//    func applyBorder(_ border:CGFloat, color:UIColor) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        let width = self.cgImage?.width
//        let height = self.cgImage?.height
//        let bits = self.cgImage?.bitsPerComponent
//        let colorSpace = self.cgImage?.colorSpace
//        let bitmapInfo = self.cgImage?.bitmapInfo
//        let context = CGContext(data: nil, width: width, height: height!, bitsPerComponent: bits!, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo?.rawValue)
//        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
//        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//        context.setStrokeColor(red: red, green: green, blue: blue, alpha: alpha)
//        context.setLineWidth(border)
//        let rect = CGRect(x: 0, y: 0, width: size.width*scale, height: size.height*scale)
//        let inset = rect.insetBy(dx: border*scale, dy: border*scale)
//        context.strokeEllipse(in: inset)
//        context.draw(self.cgImage, in: inset)
//        let image = UIImage(cgImage: context.makeImage()!)
//        UIGraphicsEndImageContext()
//        return image
//    }
    
    // MARK: Image Effects
    
    /**
     Applies a light blur effect to the image
     
     - Returns New image or nil
     */
    func applyLightEffect() -> UIImage? {
        return applyBlur(30, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8)
    }
    
    /**
     Applies a extra light blur effect to the image
     
     - Returns New image or nil
     */
    func applyExtraLightEffect() -> UIImage? {
        return applyBlur(20, tintColor: UIColor(white: 0.97, alpha: 0.82), saturationDeltaFactor: 1.8)
    }
    
    /**
     Applies a dark blur effect to the image
     
     - Returns New image or nil
     */
    func applyDarkEffect() -> UIImage? {
        return applyBlur(20, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)
    }
    
    /**
     Applies a color tint to an image
     
     - Parameter color: The tint color
     
     - Returns New image or nil
     */
    func applyTintEffect(_ tintColor: UIColor) -> UIImage? {
        let effectColorAlpha: CGFloat = 0.6
        var effectColor = tintColor
        let componentCount = tintColor.cgColor.numberOfComponents
        if componentCount == 2 {
            var b: CGFloat = 0
            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor(white: b, alpha: effectColorAlpha)
            }
        } else {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            
            if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
                effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
            }
        }
        return applyBlur(10, tintColor: effectColor, saturationDeltaFactor: -1.0)
    }
    
    /**
     Applies a blur to an image based on the specified radius, tint color saturation and mask image
     
     - Parameter blurRadius: The radius of the blur.
     - Parameter tintColor: The optional tint color.
     - Parameter saturationDeltaFactor: The detla for saturation.
     - Parameter maskImage: The optional image for masking.
     
     - Returns New image or nil
     */
    func applyBlur(_ blurRadius:CGFloat, tintColor:UIColor?, saturationDeltaFactor:CGFloat, maskImage:UIImage? = nil) -> UIImage? {
        guard size.width > 0 && size.height > 0 && cgImage != nil else {
            return nil
        }
        if maskImage != nil {
            guard maskImage?.cgImage != nil else {
                return nil
            }
        }
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        var effectImage = self
        let hasBlur = blurRadius > CGFloat(Float.ulpOfOne)  //CGFloat(FLT_EPSILON)
        let hasSaturationChange = fabs(saturationDeltaFactor - 1.0) > CGFloat(Float.ulpOfOne)
        if (hasBlur || hasSaturationChange) {
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            let effectInContext = UIGraphicsGetCurrentContext()
            effectInContext?.scaleBy(x: 1.0, y: -1.0)
            effectInContext?.translateBy(x: 0, y: -size.height)
            effectInContext?.draw(cgImage!, in: imageRect)
            
            var effectInBuffer = vImage_Buffer(
                data: effectInContext?.data,
                height: UInt((effectInContext?.height)!),
                width: UInt((effectInContext?.width)!),
                rowBytes: (effectInContext?.bytesPerRow)!)
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
            let effectOutContext = UIGraphicsGetCurrentContext()
            
            var effectOutBuffer = vImage_Buffer(
                data: effectOutContext?.data,
                height: UInt((effectOutContext?.height)!),
                width: UInt((effectOutContext?.width)!),
                rowBytes: (effectOutContext?.bytesPerRow)!)
            
            if hasBlur {
                let inputRadius = blurRadius * UIScreen.main.scale
                let s = floor(inputRadius * 3.0 * CGFloat(sqrt(2.0 * Double.pi)) / 4.0 + 0.5)
                var radius = UInt32(s)
                if radius % 2 != 1 {
                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
                }
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            var effectImageBuffersAreSwapped = false
            
            if hasSaturationChange {
                let s: CGFloat = saturationDeltaFactor
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1
                ]
                
                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
                
                for i: Int in 0 ..< matrixSize {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let outputContext = UIGraphicsGetCurrentContext()
        outputContext?.scaleBy(x: 1.0, y: -1.0)
        outputContext?.translateBy(x: 0, y: -size.height)
        
        // Draw base image.
        outputContext?.draw(self.cgImage!, in: imageRect)
        
        // Draw effect image.
        if hasBlur {
            outputContext?.saveGState()
            if let image = maskImage {
                outputContext?.clip(to: imageRect, mask: image.cgImage!);
            }
            outputContext?.draw(effectImage.cgImage!, in: imageRect)
            outputContext?.restoreGState()
        }
        
        // Add in color tint.
        if let color = tintColor {
            outputContext?.saveGState()
            outputContext?.setFillColor(color.cgColor)
            outputContext?.fill(imageRect)
            outputContext?.restoreGState()
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
        
    }
}

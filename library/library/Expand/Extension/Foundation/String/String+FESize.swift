//
//  CGFloat+DesignSize.swift
//  Hzy
//
//  Created by hzf on 2017/5/12.
//  Copyright © 2017年 Hzy. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func attrib(color: UIColor, size: CGFloat)-> NSAttributedString{
        let str = NSAttributedString(string: self, attributes: [NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)])
        return str
    }
    func mattrib(color: UIColor, size: CGFloat)-> NSMutableAttributedString{
        let str = NSMutableAttributedString(string: self, attributes: [NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)])
        return str
    }
}

extension String {
    
    /**
     富文本的高度
     */
    func heightWithStringAttributes(_ attributes : [NSAttributedStringKey : AnyObject], fixedWidth : CGFloat) -> CGFloat {
        
        guard self.count > 0 && fixedWidth > 0 else {
            
            return 0
        }
        
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size.height
    }
    
    /**
     文字的高度
     */
    func heightWithFont(_ font : UIFont = UIFont.systemFont(ofSize: 18), fixedWidth : CGFloat) -> CGFloat {
        
        guard self.count > 0 && fixedWidth > 0 else {
            
            return 0
        }
        
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:[.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : font], context:nil)
        
        return rect.size.height
    }
    
    /**
     富文本的宽度
     */
    func widthWithStringAttributes(_ attributes : [NSAttributedStringKey : AnyObject]) -> CGFloat {
        
        guard self.count > 0 else {
            
            return 0
        }
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size.width
    }
    
    /**
     文字的宽度
     */
    func widthWithFont(_ font : UIFont = UIFont.systemFont(ofSize: 18)) -> CGFloat {
        
        guard self.count > 0 else {
            
            return 0
        }
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let text = self as NSString
//        self.size(withAttributes: [NSAttributedStringKey.font : font])
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context:nil)
        
        return rect.size.width
    }
}

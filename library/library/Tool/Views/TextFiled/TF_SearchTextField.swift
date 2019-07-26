//
//  TF_SearchTextField.swift
//  DidaSystem
//
//  Created by hzf on 2017/12/7.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit

class TF_SearchTextField: UITextField {

    var placeholderColor: UIColor = BaseColor.gray_7c7e86
    var placeholderFont: UIFont = UIFont.systemFont(ofSize: 14)
    var iconPlaceholderSpace: CGFloat = 10
    
    init() {
       super.init(frame: .zero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(){
        self.font = UIFont.systemFont(ofSize: 14)
        self.tintColor = BaseColor.black_121213
        self.backgroundColor = BaseColor.bgAndLine_f5f5f7
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(x: 15, y: bounds.origin.y, width: bounds.size.width - 30, height: bounds.size.height)
        return rect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(x: 15, y: bounds.origin.y, width: bounds.size.width - 30, height: bounds.size.height)
        return rect
    }
    
    override func drawPlaceholder(in rect: CGRect) {
        let searchIcon = #imageLiteral(resourceName: "smallsearch")
        if let placeholder = self.placeholder, placeholder != "" {
            
            let searchIconSize = CGSize(width: 13, height: 13)
            let placeholderSize = placeholder.size(withAttributes: [NSAttributedString.Key.font : placeholderFont])

            let searchIconOrigin = CGPoint(x: (rect.size.width - searchIconSize.width - placeholderSize.width - iconPlaceholderSpace)/2, y: (rect.size.height - searchIconSize.height)/2)
            let placeholderOrigin = CGPoint(x: searchIconOrigin.x+searchIconSize.width+iconPlaceholderSpace, y: (rect.size.height - placeholderSize.height)/2)

            let searchIconRect = CGRect(origin: searchIconOrigin, size: searchIconSize)
            let placeholderRect = CGRect(origin: placeholderOrigin, size: placeholderSize)
            searchIcon.draw(in: searchIconRect)
            placeholder.draw(in: placeholderRect, withAttributes: [NSAttributedString.Key.font : placeholderFont,
                                                                   NSAttributedString.Key.foregroundColor: placeholderColor
                ])
        } else {
            let searchIconSize = CGSize(width: 13, height: 13)
            let searchIconOrigin = CGPoint(x: (rect.size.width - searchIconSize.width)/2, y: (rect.size.height - searchIconSize.height)/2)
            let searchIconRect = CGRect(origin: searchIconOrigin, size: searchIconSize)
            searchIcon.draw(in: searchIconRect)
        }
    }
}

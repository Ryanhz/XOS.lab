//
//  TF_CornersTextField.swift
//  DidaSystem
//
//  Created by hzf on 2017/12/12.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit

class TF_CornersTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.height/2
        self.layer.masksToBounds = true
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        //        super.placeholderRect(forBounds: <#T##CGRect#>)
        var frame = bounds
        frame.origin.x += 25
        return frame
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var frame = bounds
        frame.origin.x += 10
        frame.size.width -= 20
        return frame
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var frame = bounds
        frame.origin.x += 10
        frame.size.width -= 20
        return frame
    }
}

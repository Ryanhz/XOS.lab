//
//  UIScreenExtension.swift
//  FETools
//
//  Created by hzf on 2017/11/1.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit

//extension UIScreen: HzyNamespaceWrappable {}

extension HzyNamespaceWrapper where T: UIScreen {
    
    static var size: CGSize { return UIScreen.main.bounds.size }
    
    static var width: CGFloat { return self.size.width }
    
    static var height: CGFloat { return self.size.height }
    
    static var scale: CGFloat { return UIScreen.main.scale }
    
    static var bounds: CGRect { return UIScreen.main.bounds }
}



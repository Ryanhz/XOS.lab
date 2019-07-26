//
//  Screen+Extend.swift
//  RecordVideo
//
//  Created by hzf on 2017/4/20.
//  Copyright © 2017年 FE. All rights reserved.
//

import UIKit

extension UIScreen {
    
    class var size: CGSize {
        return UIScreen.main.bounds.size
    }
    
    class var minWidth: CGFloat {
        return min(self.size.width, self.size.height)
    }
    
    class var maxHeight: CGFloat {
        return max(self.size.width, self.size.height)
    }
    
    class var width: CGFloat {
        return min(self.size.width, self.size.height)
    }
    
    class var height: CGFloat {
        return max(self.size.width, self.size.height)
    }
    
    class var mainScale: CGFloat {
        return UIScreen.main.scale
    }
    
    class var mainbounds: CGRect {
        return UIScreen.main.bounds
    }
    
}

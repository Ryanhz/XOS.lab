//
//  TF_BaseJsonModel.swift
//  DidaSystem
//
//  Created by hzf on 2017/7/20.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit
import HandyJSON
class HzyOBaseJsonModel: NSObject, HandyJSON {
    
    required override init() {}
    
    override var debugDescription: String {
        return self.toJSONString() ?? ""
    }
    
    override var description: String {
        return self.toJSONString() ?? ""
    }
}

class HzyBaseJsonModel: HandyJSON, CustomDebugStringConvertible, CustomStringConvertible {
    required init() {}
    var debugDescription: String {
        return self.toJSONString() ?? ""
    }
    
    var description: String {
        return self.toJSONString() ?? ""
    }
}

protocol HzySBaseJsonModel: HandyJSON, CustomDebugStringConvertible, CustomStringConvertible{}

extension HzySBaseJsonModel {
    
    var debugDescription: String {
        return self.toJSONString() ?? ""
    }
    
    var description: String {
        return self.toJSONString() ?? ""
    }
}

struct HzyModel: HzySBaseJsonModel {
    
}


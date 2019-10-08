//
//  TF_BaseJsonModel.swift
//  DidaSystem
//
//  Created by hzf on 2017/7/20.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit
import HandyJSON
class ZymeOBaseJsonModel: NSObject, HandyJSON {
    
    required override init() {}
    
    override var debugDescription: String {
        return self.toJSONString() ?? ""
    }
    
    override var description: String {
        return self.toJSONString() ?? ""
    }
}

class ZymeBaseJsonModel: HandyJSON, CustomDebugStringConvertible, CustomStringConvertible {
    required init() {}
    var debugDescription: String {
        return self.toJSONString() ?? ""
    }
    
    var description: String {
        return self.toJSONString() ?? ""
    }
}

protocol ZymeSBaseJsonModel: HandyJSON, CustomDebugStringConvertible, CustomStringConvertible{}

extension ZymeSBaseJsonModel {
    
    var debugDescription: String {
        return self.toJSONString() ?? ""
    }
    
    var description: String {
        return self.toJSONString() ?? ""
    }
}

struct ZymeModel: ZymeSBaseJsonModel {
    
}


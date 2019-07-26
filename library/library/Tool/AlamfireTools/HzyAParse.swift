//
//  TF_AParse.swift
//  DidaSystem
//
//  Created by hzf on 2017/8/4.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit
import HandyJSON

struct HzyAParse: HzyADecodable {
    init(json: Any) throws {}
}

struct HzyAStringParse:  HzyADecodable{
    
    var data: String
    init(json: Any) throws  {
        guard let data = json as? String else {
            throw HzyNetError.jsonTransformModelFailed(.dataTypeNotMatch("json is not Sting"))
        }
        self.data = data
    }
}

struct HzyAIntParse: HzyADecodable{
    var data: Int
    init(json: Any) throws  {
        guard let data = json as? Int else {
            throw HzyNetError.jsonTransformModelFailed(.dataTypeNotMatch("json is not Int"))
        }
        self.data = data
    }
}

struct HzyObjectParse<T: HandyJSON>: HzyADecodable{
    
    var model: T = T()
    
    init(json: Any) throws  {
        
        guard let data = json as? [String: Any] else {
            throw HzyNetError.jsonTransformModelFailed(.dataTypeNotMatch("json is not [String: Any] type"))
        }
        
        let nDic = data as NSDictionary
        guard let model = T.deserialize(from: nDic) else {
            throw HzyNetError.jsonTransformModelFailed(.deserialize("\(T.self) deserialize Failed"))
        }
        self.model = model
    }
}

struct HzyArrayParse<T: HandyJSON>:  HzyADecodable {
    
    var models: [T] = [T]()
    
    init(json: Any) throws  {
        
        guard let data = json as? [[String: Any]] else {
            throw HzyNetError.jsonTransformModelFailed(.dataTypeNotMatch("json is not [[String: Any]] type"))
        }
        
        for item in data {
            let nDic = item as NSDictionary
            if let model = T.deserialize(from: nDic) {
                self.models.append(model)
            } else {
                hzyNetDebugLog("\(T.self) from \(nDic) deserialize Failed")
//                throw HzyNetError.jsonTransformModelFailed(.deserialize("\(T.self) deserialize Failed"))
            }
        }
        
    }
}





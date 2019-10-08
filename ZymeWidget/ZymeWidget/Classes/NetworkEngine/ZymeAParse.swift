//
//  TF_AParse.swift
//  DidaSystem
//
//  Created by hzf on 2017/8/4.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit
import HandyJSON

struct ZymeAParse: ZymeADecodable {
    init(json: Any) throws {}
}

struct ZymeAStringParse:  ZymeADecodable{
    
    var data: String
    init(json: Any) throws  {
        guard let data = json as? String else {
            throw ZymeNetError.jsonTransformModelFailed(.dataTypeNotMatch("json is not Sting"))
        }
        self.data = data
    }
}

struct ZymeAIntParse: ZymeADecodable{
    var data: Int
    init(json: Any) throws  {
        guard let data = json as? Int else {
            throw ZymeNetError.jsonTransformModelFailed(.dataTypeNotMatch("json is not Int"))
        }
        self.data = data
    }
}

struct ZymeObjectParse<T: HandyJSON>: ZymeADecodable{
    
    var model: T = T()
    
    init(json: Any) throws  {
        
        guard let data = json as? [String: Any] else {
            throw ZymeNetError.jsonTransformModelFailed(.dataTypeNotMatch("json is not [String: Any] type"))
        }
        
        let nDic = data as NSDictionary
        guard let model = T.deserialize(from: nDic) else {
            throw ZymeNetError.jsonTransformModelFailed(.deserialize("\(T.self) deserialize Failed"))
        }
        self.model = model
    }
}

struct ZymeArrayParse<T: HandyJSON>:  ZymeADecodable {
    
    var models: [T] = [T]()
    
    init(json: Any) throws  {
        
        guard let data = json as? [[String: Any]] else {
            throw ZymeNetError.jsonTransformModelFailed(.dataTypeNotMatch("json is not [[String: Any]] type"))
        }
        
        for item in data {
            let nDic = item as NSDictionary
            if let model = T.deserialize(from: nDic) {
                self.models.append(model)
            } else {
                zymeNetDebugLog("\(T.self) from \(nDic) deserialize Failed")
//                throw ZymeNetError.jsonTransformModelFailed(.deserialize("\(T.self) deserialize Failed"))
            }
        }
        
    }
}





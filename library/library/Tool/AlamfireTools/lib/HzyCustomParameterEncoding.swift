//
//  TF_.swift
//  DidaSystem
//
//  Created by hzf on 2017/7/25.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit
import Alamofire

struct JSONStringEncoding: ParameterEncoding {
    
    private let para: Any
    
    init(para: Any) {
        self.para = para
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        let data = try JSONSerialization.data(withJSONObject: para, options: [])
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        urlRequest.httpBody = data
        return urlRequest
    }
}



/// post array
struct JSONArrayEncoding: ParameterEncoding {
    
    enum JSONArrayEncodingError: Error {
        case formattError
    }
    
    private let packPara: [String: Any]
    private let packKey: String
    
    init(packPara: [String: Any], packKey: String) {
        self.packPara = packPara
        self.packKey = packKey
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let array = packPara[packKey] else {
            throw JSONArrayEncodingError.formattError
        }
        
        let data = try JSONSerialization.data(withJSONObject: array, options: [])
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        urlRequest.httpBody = data
        return urlRequest
    }
}


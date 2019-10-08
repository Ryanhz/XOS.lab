//
//  TF_InterviewReport.swift
//  SteeringIphone
//
//  Created by hzf on 2017/9/15.
//  Copyright © 2017年 施文斌. All rights reserved.
//

import UIKit
import Alamofire

public struct ZymeRequsetConfig {
    
    var parameter: [String: Any]?
    var url: String?
    var method: ZymeHTTPMethod?
    var requestPolicy: ZymeRequestPolicy?
    
    init(parameter: [String: Any]? = nil, url: String? = nil, method: ZymeHTTPMethod? = nil, requestPolicy: ZymeRequestPolicy? = nil) {
        self.parameter = parameter
        self.url = url
        self.method = method
        self.requestPolicy = requestPolicy
    }
}

public class ZymeARequest: ZymeARequestType {
    
    typealias Parse = ZymeAParse
    
    var config: ZymeRequsetConfig?
    
    var privateURL: String? {
        return config?.url
    }
    
    var parameter: [String: Any]? {
        return config?.parameter
    }
    var method: ZymeHTTPMethod {
        return config?.method ?? .get
    }
    
    var requestPolicy: ZymeRequestPolicy {
        return config?.requestPolicy ?? .noCache
    }
    
    var path: String { return "" }
    
    init(config: ZymeRequsetConfig) {
        self.config = config
    }
}








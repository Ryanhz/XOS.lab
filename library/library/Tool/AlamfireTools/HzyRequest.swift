//
//  TF_InterviewReport.swift
//  SteeringIphone
//
//  Created by hzf on 2017/9/15.
//  Copyright © 2017年 施文斌. All rights reserved.
//

import UIKit
import Alamofire

struct HzyRequsetConfig {
    
    var parameter: [String: Any]?
    var url: String?
    var method: HzyHTTPMethod?
    var requestPolicy: HzyRequestPolicy?
    
    init(parameter: [String: Any]? = nil, url: String? = nil, method: HzyHTTPMethod? = nil, requestPolicy: HzyRequestPolicy? = nil) {
        self.parameter = parameter
        self.url = url
        self.method = method
        self.requestPolicy = requestPolicy
    }
}

class HzyARequest: HzyARequestType {
    
    typealias Parse = HzyAParse
    
    var config: HzyRequsetConfig?
    
    var privateURL: String? {
        return config?.url
    }
    
    var parameter: [String: Any]? {
        return config?.parameter
    }
    var method: HzyHTTPMethod {
        return config?.method ?? .get
    }
    
    var requestPolicy: HzyRequestPolicy {
        return config?.requestPolicy ?? .noCache
    }
    
    var path: String { return "" }
    
    init(config: HzyRequsetConfig) {
        self.config = config
    }
}








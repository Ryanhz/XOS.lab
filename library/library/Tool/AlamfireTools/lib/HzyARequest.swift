//
//  FE_ARequest.swift
//  Hzy
//
//  Created by hzf on 2017/5/11.
//  Copyright © 2017年 Hzy. All rights reserved.
//

import Foundation
import Alamofire

public enum HzyHTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum HzyRequestPolicy {
    ///如果缓存有效只使用缓存 缓存有效期单位：秒
    case useCacheIfValid(Double)
    ///先加载缓存再请求
    case useCacheAndRequestNet
    /// 不使用缓存
    case noCache
    
    var isUseCacheIfValid: Bool {
        switch self {
        case .useCacheIfValid(_): return true
        default:
            return false
        }
    }
}

extension HzyRequestPolicy: Equatable {
    
    static func ==(lhs: HzyRequestPolicy, rhs: HzyRequestPolicy) -> Bool {
        switch (lhs, rhs) {
        case (noCache, noCache), (useCacheAndRequestNet, useCacheAndRequestNet):
            return true
        case (useCacheIfValid(let lhsTime),useCacheIfValid(let rhsTime)):
            return lhsTime == rhsTime
        default:
            return false
        }
    }
}

//protocol HzyARequestParameterable {
//
//    var
//}
//
//extension HzyARequestParameterable {
//
//}

protocol HzyARequestType {
    
    var requestPolicy: HzyRequestPolicy { get }
    
    var path: String { get }
    
    var method: HzyHTTPMethod { get }
    
    var parameter: [String: Any]? { get }
    
    var timeoutInterval: TimeInterval { get }
    
    var privateURL: String? { get }
        
    var headers: [String: String]? { get }
    
    var encoding: ParameterEncoding { get }
    
    var isOpenActivityIndicator: Bool { get }
    
    associatedtype Parse: HzyADecodable
}

extension HzyARequestType {
    
    var timeoutInterval: TimeInterval {
        return 5
    }
    
    var privateURL: String? {
        return nil
    }
    
    var encoding: ParameterEncoding {
        return method == .get || method == .head || method == .delete ? URLEncoding.default : URLEncoding.httpBody
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var isOpenActivityIndicator: Bool {
        return true
    }
    
    var parameter: [String: Any]? {
        return nil
    }
    
    var method: HzyHTTPMethod {
        return .get
    }
    
    var requestPolicy: HzyRequestPolicy{
        return .noCache
    }
}

protocol HzyAUpdataRequestType: HzyARequestType {
    var updata: [HzyAUpdataType] { get set }
}









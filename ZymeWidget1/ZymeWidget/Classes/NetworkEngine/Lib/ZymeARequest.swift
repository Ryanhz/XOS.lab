//
//  FE_ARequest.swift
//  Zyme
//
//  Created by hzf on 2017/5/11.
//  Copyright © 2017年 Zyme. All rights reserved.
//

import Foundation
import Alamofire

public enum ZymeHTTPMethod: String {
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

enum ZymeRequestPolicy {
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

extension ZymeRequestPolicy: Hashable{}


extension ZymeRequestPolicy: Equatable {
    
    static func ==(lhs: ZymeRequestPolicy, rhs: ZymeRequestPolicy) -> Bool {
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

//protocol ZymeARequestParameterable {
//
//    var
//}
//
//extension ZymeARequestParameterable {
//
//}

protocol ZymeARequestType {
    
    var requestPolicy: ZymeRequestPolicy { get }
    
    var path: String { get }
    
    var method: ZymeHTTPMethod { get }
    
    var parameter: [String: Any]? { get }
    
    var timeoutInterval: TimeInterval { get }
    
    var privateURL: String? { get }
        
    var headers: [String: String]? { get }
    
    var encoding: ParameterEncoding { get }
    
    var isOpenActivityIndicator: Bool { get }
    
    associatedtype Parse: ZymeADecodable
}

extension ZymeARequestType {
    
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
    
    var method: ZymeHTTPMethod {
        return .get
    }
    
    var requestPolicy: ZymeRequestPolicy{
        return .noCache
    }
}

protocol ZymeAUpdataRequestType: ZymeARequestType {
    var updata: [ZymeAUpdataType] { get set }
}









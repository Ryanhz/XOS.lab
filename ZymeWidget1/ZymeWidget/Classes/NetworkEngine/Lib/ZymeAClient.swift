//
//  FE_AlamofireClient.swift
//  Zyme
//
//  Created by hzf on 2017/5/11.
//  Copyright © 2017年 Zyme. All rights reserved.
//

import Foundation
import Alamofire
//import

enum ZymeResponseType<T> {
    case success(T)
    case failure(String)
}

protocol ZymeAClient {
    
    var host: String { get }
        
    func transformHashKey(urlString: String, parameters:  [String: Any]?) -> String
}

extension ZymeAClient {
    
    func transformHashKey<T: ZymeARequestType>(request: T) -> String {
        let url = URL(string: request.privateURL ?? host.appending(request.path))!
        let httpHashKey = transformHashKey(urlString: url.absoluteString, parameters: request.parameter)
        return httpHashKey
    }
    
    func transformHashKey(urlString: String, parameters:  [String: Any]?) -> String {
        guard let para = parameters,
            para.count > 0,
            let paraData = try? JSONSerialization.data(withJSONObject: para, options: []),
            let paraString = String(data: paraData, encoding: .utf8) else {
                return urlString.zyme.md5
        }
        return (urlString + paraString).zyme.md5
    }
}

protocol ZymeNetClosure {
    
    typealias ProgressClosure = (Progress)->Void
    
    typealias ParserClosure<T: ZymeARequestType> = (ZymeResponseType<T.Parse>)->Void
    
    typealias UploadTaskClosure<T: ZymeARequestType> = (ZymeRequestTask<T>?)->Void
}

protocol ZymeNetFunc: ZymeNetClosure {
    func parseResponse<T: ZymeARequestType>(r: T, responseData: Data?, parserClosure: ParserClosure<T>)
}

extension ZymeNetFunc {
    
    func parseResponse<T: ZymeARequestType>(r: T, responseData: Data?, parserClosure: ParserClosure<T>) {
        do {
            let jsonObject = try T.Parse.validate(data: responseData)
            zymeNetDebugLog("\(r.method),\(r.requestPolicy) \(r.path),\(jsonObject)" )

            let res = try T.Parse.init(json: jsonObject)
            parserClosure(ZymeResponseType.success(res))
        } catch let error as ZymeNetError {
            zymeNetDebugLog("\(r.method),\(r.requestPolicy) \(r.path),error:\(error.localizedDescription)" )
            parserClosure(ZymeResponseType.failure(error.localizedDescription))
        } catch  {
            //不会出现
            zymeNetDebugLog("\(r.method),\(r.requestPolicy) \(r.path),error:\(error.localizedDescription)" )
            parserClosure(ZymeResponseType.failure(error.localizedDescription))
        }
    }
}



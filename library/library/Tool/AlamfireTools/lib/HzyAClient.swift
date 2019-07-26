//
//  FE_AlamofireClient.swift
//  Hzy
//
//  Created by hzf on 2017/5/11.
//  Copyright © 2017年 Hzy. All rights reserved.
//

import Foundation
import Alamofire

enum HzyResponseType<T> {
    case success(T)
    case failure(String)
}

protocol HzyAClient {
    
    var host: String { get }
        
    func transformHashKey(urlString: String, parameters:  [String: Any]?) -> String
}

extension HzyAClient {
    
    func transformHashKey<T: HzyARequestType>(request: T) -> String {
        let url = URL(string: request.privateURL ?? host.appending(request.path))!
        let httpHashKey = transformHashKey(urlString: url.absoluteString, parameters: request.parameter)
        return httpHashKey
    }
    
    func transformHashKey(urlString: String, parameters:  [String: Any]?) -> String {
        guard let para = parameters,
            para.count > 0,
            let paraData = try? JSONSerialization.data(withJSONObject: para, options: []),
            let paraString = String(data: paraData, encoding: .utf8) else {
                return urlString.hzy.md5
        }
        return (urlString + paraString).hzy.md5
    }
}

protocol HzyNetClosure {
    
    typealias ProgressClosure = (Progress)->Void
    
    typealias ParserClosure<T: HzyARequestType> = (HzyResponseType<T.Parse>)->Void
    
    typealias UploadTaskClosure<T: HzyARequestType> = (HzyRequestTask<T>?)->Void
}

protocol HzyNetFunc: HzyNetClosure {
    func parseResponse<T: HzyARequestType>(r: T, responseData: Data?, parserClosure: ParserClosure<T>)
}

extension HzyNetFunc {
    
    func parseResponse<T: HzyARequestType>(r: T, responseData: Data?, parserClosure: ParserClosure<T>) {
        do {
            let jsonObject = try T.Parse.validate(data: responseData)
            hzyNetDebugLog("\(r.method),\(r.requestPolicy) \(r.path),\(jsonObject)" )

            let res = try T.Parse.init(json: jsonObject)
            parserClosure(HzyResponseType.success(res))
        } catch let error as HzyNetError {
            hzyNetDebugLog("\(r.method),\(r.requestPolicy) \(r.path),error:\(error.localizedDescription)" )
            parserClosure(HzyResponseType.failure(error.localizedDescription))
        } catch  {
            //不会出现
            hzyNetDebugLog("\(r.method),\(r.requestPolicy) \(r.path),error:\(error.localizedDescription)" )
            parserClosure(HzyResponseType.failure(error.localizedDescription))
        }
    }
}



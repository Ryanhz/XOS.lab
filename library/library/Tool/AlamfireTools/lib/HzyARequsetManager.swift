//
//  FE_AlamofireTools.swift
//  Hzy
//
//  Created by hzf on 2017/5/11.
//  Copyright © 2017年 Hzy. All rights reserved.
//

import UIKit
import Alamofire

public final class HzyARequsetManager: HzyAClient, HzyNetFunc {
    
    private static let _shared = HzyARequsetManager()

    static var isBugPrint: Bool = true
    
    public static var shared: HzyARequsetManager {
        return _shared
    }

    var host: String {
        return HzyNet.hostType.host
    }
    
    fileprivate var requestTasks = [String: Any]()
    
    func cancel<T: HzyARequestType>(_ r: T) {
       
        let url = URL(string: r.privateURL ?? host.appending(r.path))!
        
        let httpHashKey = transformHashKey(urlString: url.absoluteString, parameters: r.parameter)
        
        guard let task = requestTasks[httpHashKey] as? HzyRequestTask<T> else {
            return
        }
        task.requset.cancel()
        requestTasks.removeValue(forKey: httpHashKey)
    }
    
    func removeHttpCache<T: HzyARequestType>(_ r: T) {
        let url = URL(string: r.privateURL ?? host.appending(r.path))!
        
        let httpHashKey = transformHashKey(urlString: url.absoluteString, parameters: r.parameter)
        HzyNetworkCache.shared?.removeHttpCache(cacheKey: httpHashKey)
    }
    
    func removeAllHttpCache(){
         HzyNetworkCache.shared?.removeAllHttpCache()
    }
}

extension HzyARequsetManager {
    
    @discardableResult
    static func send<T: HzyARequestType>(_ r: T) -> HzyRequestTask<T> {
        return self.shared.send(r)
    }
    
    // MARK: - put get post DELETE
    @discardableResult
    func send<T: HzyARequestType>(_ r: T) -> HzyRequestTask<T> {
        
        let url = URL(string: r.privateURL ?? host.appending(r.path))!
        
        let httpHashKey = transformHashKey(urlString: url.absoluteString, parameters: r.parameter)
        
        if let task =  requestTasks[httpHashKey] as? HzyRequestTask<T>  {
            return task
        } else {
            let taskManager = HzyRequestTask(r,
                                             url: url,
                                             httpHashKey: httpHashKey,
                                             requestPolicy: r.requestPolicy,
                                             completion: {
                                                self.requestTasks.removeValue(forKey: httpHashKey)
                                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                                
            })
            
            requestTasks[httpHashKey] = taskManager
            return taskManager
        }
    }
}

extension HzyRequestTask: HzyNetFunc {
    
    @discardableResult
    func cache(parserClosure: @escaping ParserClosure<T>) -> HzyRequestTask {
        self.parseResponse(r: self.aRequset, responseData: self.response.cacheData) { responseType in
            parserClosure(responseType)
        }
        return self
    }
    
    @discardableResult
    func complete(parserClosure: @escaping ParserClosure<T>) -> HzyRequestTask {
        self.response.response(completion: { (data) in
            self.parseResponse(r: self.aRequset, responseData: data, parserClosure: parserClosure)
        })
        return self
    }
}

extension HzyARequsetManager {
    
    class func upload<T: HzyAUpdataRequestType>(_ r: T, uploadProgress: ProgressClosure?, taskClosure: UploadTaskClosure<T>? = nil, parserClosure: @escaping ParserClosure<T>) {
        self.shared.upload(r, uploadProgress: uploadProgress, taskClosure: taskClosure, parserClosure: parserClosure)
    }
    
    // MARK: - updata
    func upload<T: HzyAUpdataRequestType>(_ r: T, uploadProgress: ProgressClosure?, taskClosure: UploadTaskClosure<T>? = nil, parserClosure: @escaping ParserClosure<T>){
        
        let url = URL(string: r.privateURL ?? host.appending(r.path))!
        Alamofire.upload(
            multipartFormData: { (multipartFormData) in
                self.uploadFormData(r: r, multipartFormData: multipartFormData)
            },
            to: url,
            encodingCompletion: { (encodingResult) in
                self.uploadEncodingCompletion(r: r,
                                              encodingResult: encodingResult,
                                              uploadProgress: uploadProgress,
                                              parserClosure: parserClosure)
                }
        )
    }
    
    private func uploadFormData<T: HzyAUpdataRequestType>(r: T, multipartFormData: MultipartFormData){
        if let param = r.parameter {
            for (key, value) in param {
                var data: Data!
                if var _ = value as? NSNumber {
                    let str = "\(value)"
                    data = str.data(using: .utf8)!
                } else if let str = value as? String {
                    data = str.data(using: .utf8)
                } else {
                    hzyNetDebugLog("\(r.path),updata: multipartFormData parameter value:\(value) is error.")
                }
                hzyNetDebugLog("key: \(key), value: \(value)")
                multipartFormData.append(data, withName: key)
            }
        }
        for  item in r.updata {
            
            if let fileURL = item.fileURL {
                multipartFormData.append(fileURL, withName: item.name, fileName: item.fileName, mimeType: item.mimeType.rawValue)
            } else if let data = item.data  {
                multipartFormData.append(data, withName: item.name, fileName: item.fileName, mimeType: item.mimeType.rawValue)
            }
        }
    }
    
   private func uploadEncodingCompletion<T: HzyAUpdataRequestType>(r: T,
                                                                   encodingResult: SessionManager.MultipartFormDataEncodingResult,
                                                                   uploadProgress: ProgressClosure?,
                                                                   taskClosure: UploadTaskClosure<T>? = nil,
                                                                   parserClosure: @escaping ParserClosure<T>) {
    
        switch encodingResult {
        case .success(request: let request, streamingFromDisk: let isStreamingFromDisk  , streamFileURL: let fileURL):
            
            let url = URL(string: r.privateURL ?? host.appending(r.path))!
            let httpHashKey = transformHashKey(urlString: url.absoluteString, parameters: r.parameter)
            
            let task = HzyRequestTask(r,
                                      url: url,
                                      httpHashKey: httpHashKey,
                                      completion: {
                                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                        self.requestTasks.removeValue(forKey: httpHashKey)
            })
            
            requestTasks[httpHashKey] = task
            taskClosure?(task)
            
            request.response(completionHandler: { (response) in
                 UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.requestTasks.removeValue(forKey: httpHashKey)
                self.parseResponse(r: r, responseData: response.data, parserClosure: parserClosure)
            })
            
//            request.responseString(completionHandler: { (response) in
//                switch response.result {
//                case .success(let str): hzyNetDebugLog("\(request) + \(str)")
//                case .failure(let error): hzyNetDebugLog("\(request) + \(error.localizedDescription)")
//                }
//            })
            
            uploadProgress?(request.uploadProgress)
            hzyNetDebugLog("isStreamingFromDisk: \(isStreamingFromDisk), fileURL: \(String(describing: fileURL))")
            
        case .failure(let error):
            taskClosure?(nil)
            parserClosure(.failure(error.localizedDescription))
        }
    }
}

class HzyRequestTask<T: HzyARequestType>: Hashable{
    
  static func ==(lhs: HzyRequestTask<T>, rhs: HzyRequestTask<T>) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    let aRequset: T
    
    let requset: DataRequest
    let response: HzyResponse
    let httpHashKey: String
    let requestPolicy: HzyRequestPolicy
    
    let sessionManager: SessionManager
    
    var hashValue: Int {
        return httpHashKey.hashValue
    }
    
    init(_ r: T, url: URL, httpHashKey: String, requestPolicy: HzyRequestPolicy = .noCache, completion: @escaping () -> Void) {
        aRequset = r
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = r.timeoutInterval
        sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = r.isOpenActivityIndicator
        }
        
        self.httpHashKey = httpHashKey
        self.requestPolicy = requestPolicy
        
        requset = sessionManager.request(url,
                                    method: HTTPMethod(rawValue: r.method.rawValue)!,
                                    parameters: r.parameter,
                                    encoding: r.encoding,
                                    headers: r.headers)
        
        self.response = HzyResponse(dataRequest: requset, httpHashKey: httpHashKey, requestPolicy: requestPolicy, completionClosure: completion)
        
        hzyNetDebugLog("\(requset) \n parameter: \(String(describing: r.parameter))")
    }
}

extension HzyRequestTask {
    
    @discardableResult
    func cacheData(completion: @escaping (Data?) -> Void ) -> HzyRequestTask {
        completion(self.response.cacheData)
        return self
    }
    
    @discardableResult
    func cacheJson(completion: @escaping (Any?) -> Void) -> HzyRequestTask {
        guard let data = self.response.cacheData, data.count > 0 else {
            completion(nil)
            return self
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            completion(json)
            return self
        } catch  {
            completion(nil)
            hzyNetDebugLog("\(self.requset)\(error)")
            return self
        }
    }
    
    @discardableResult
    func cacheString(completion: @escaping (String?) -> Void) -> HzyRequestTask {
        guard let data = self.response.cacheData, !data.isEmpty else {
            completion(nil)
            return self
        }
        let str = String(data: data, encoding: .utf8)
        completion(str)
        return self
    }
}

class HzyResponse {
    
    let dataRequest: DataRequest
    let httpHashKey: String
    let requestPolicy: HzyRequestPolicy

    fileprivate var completionClosure: (()->Void)?
    
    init(dataRequest: DataRequest, httpHashKey: String, requestPolicy: HzyRequestPolicy, completionClosure: @escaping ()->Void) {
        
        self.dataRequest = dataRequest
        self.httpHashKey = httpHashKey
        self.requestPolicy = requestPolicy
        self.completionClosure = completionClosure
    }
    
    fileprivate var cacheData: Data? {
        get {
           return getCache()
        }
            
        set {
            guard let data = newValue, !data.isEmpty else {
                return
            }
            switch requestPolicy  {
            case .noCache: return
            case .useCacheAndRequestNet:
                HzyNetworkCache.shared?.setHttpCache(data: data as NSData, cacheKey: httpHashKey)
            case .useCacheIfValid(_):
                let dateDate = Date().timeIntervalSince1970.data
                HzyNetworkCache.shared?.setHttpCache(data: [dateDate, data] as NSArray, cacheKey: httpHashKey)
            }
        }
    }
    
    private func getCache()->Data? {
        let getDataBlock: (Double, String)->Data? = {(validTime,httpHashKey) in
            
                guard let dataArray = HzyNetworkCache.shared?.httpCacheFor(cacheKey: httpHashKey) as? NSArray,
                    dataArray.count == 2,
                let dateData = dataArray[0] as? Data,
                let archiveDate = Double(data: dateData),
                    Date().timeIntervalSince1970 - archiveDate < validTime,
                 let cacheData = dataArray[1] as? Data else {
                    return nil
                }
                return cacheData
            }
        
            switch requestPolicy {
            case .noCache: return nil
            case .useCacheAndRequestNet:
                return HzyNetworkCache.shared?.httpCacheFor(cacheKey: httpHashKey) as? Data
            case .useCacheIfValid(let time):
                return getDataBlock(time, httpHashKey)
        }
    }
}

extension HzyResponse {
    @discardableResult
    func response(completion: @escaping (Data?) -> Void ) -> HzyResponse {
    
        if requestPolicy.isUseCacheIfValid, let cacheData = self.cacheData {
            completion(cacheData)
            return self
        }
        
        dataRequest.response(queue: nil) { (response) in
            self.completionClosure?()
            self.completionClosure = nil
            completion(response.data)
            guard response.error == nil else{
                return
            }
            self.cacheData = response.data
        }
        return self
    }
    
    @discardableResult
    func responseData(completion: @escaping (Alamofire.Result<Data>) -> Void ) -> HzyResponse {
        if requestPolicy.isUseCacheIfValid, let cacheData = self.cacheData {
            completion(Alamofire.Result.success(cacheData))
            return self
        }
        
        dataRequest.responseData(queue: nil) { (response) in
            self.completionClosure?()
            self.completionClosure = nil
            completion(response.result)
            guard response.result.isSuccess else{
                return
            }
            self.cacheData = response.data
        }
        return self
    }
    
    @discardableResult
    func responseJson(completion: @escaping (Alamofire.Result<Any>) -> Void) -> HzyResponse {
        
        if requestPolicy.isUseCacheIfValid,
            let cacheData = self.cacheData,
            let json = try? JSONSerialization.jsonObject(with: cacheData, options: [])  {
            completion(Alamofire.Result.success(json))
            return self
        }

        dataRequest.responseJSON { (response) in
            self.completionClosure?()
            self.completionClosure = nil
            completion(response.result)
            guard response.result.isSuccess else{
                return
            }
            self.cacheData = response.data
        }
        return self
    }
    
    @discardableResult
    func responseString(completion: @escaping (Alamofire.Result<String>) -> Void)  -> HzyResponse {
        if requestPolicy.isUseCacheIfValid,
            let cacheData = self.cacheData,
            let string = String(data: cacheData, encoding: .utf8)  {
            completion(Alamofire.Result.success(string))
            return self
        }
        
        dataRequest.responseString(completionHandler: { response in
            self.completionClosure?()
            self.completionClosure = nil
            completion(response.result)
            guard response.result.isSuccess else{
                return
            }
            self.cacheData = response.data
        })
        return self
    }

}

//
//  ZymeDownloadManager.swift
//  FETools
//
//  Created by hzf on 2017/11/3.
//  Copyright © 2017年 hzf. All rights reserved.
//

import Foundation
import Alamofire
fileprivate enum ZymeDownloadPath: String {
    
    case progress = "progress.plist"
    case resumeData = "resumeData.plist"
    case downloadData = "downloadData.plist"
    
    var url: URL {
        return ZymeDownloadPath.cacheDirectory.appendingPathComponent(self.rawValue)
    }
    
    var pilst: NSMutableDictionary {
        guard let dict = NSMutableDictionary(contentsOf: self.url) else {
            return NSMutableDictionary()
        }
        return dict
    }
    
    static let cacheDirectory: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("Download")
    
    static let downloadDirectory: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("Download/data")
    
}

final class ZymeDownloadPlistManager {
    
   static let shared: ZymeDownloadPlistManager = ZymeDownloadPlistManager()
    private(set) var progressPlist: NSMutableDictionary = ZymeDownloadPath.progress.pilst
    private(set) var resumeDataPlist: NSMutableDictionary = ZymeDownloadPath.resumeData.pilst
    private(set) var downloadDataPlist: NSMutableDictionary = ZymeDownloadPath.downloadData.pilst
    private init() {}
}

final class ZymeDownloadManager: ZymeAClient {
    
    var host: String {
        return ZymeNet.hostType.host
    }
    
    static let `default` = ZymeDownloadManager()
    
    fileprivate var downloadTasks = [String: Any]()
    
    @discardableResult
    func download<T: ZymeARequestType>(_ r: T) -> ZymeDownloadTask<T>{
        
        let url = URL(string: r.privateURL ?? host.appending(r.path))!
        let httpHashKey = transformHashKey(urlString: url.absoluteString, parameters: r.parameter)
        
        if let downloadTask = downloadTasks[httpHashKey] as? ZymeDownloadTask<T> {
            return downloadTask
        } else {
            let downloadTask = ZymeDownloadTask(r, url: url, httpHashKey: httpHashKey)
            downloadTasks[httpHashKey] = downloadTask
            downloadTask.cancelOrCompletion = {
                self.downloadTasks.removeValue(forKey: httpHashKey)
            }
            return downloadTask
        }
    }
    
    private init(){}
    
    func cancel<T: ZymeARequestType>(request: T) {
        
        let httpHashKey = transformHashKey(request: request)
        
        guard let task = downloadTasks[httpHashKey] as? ZymeDownloadTask<T> else {
            return
        }
        
        task.requset.cancel()
        task.cancelOrCompletion = {
            self.downloadTasks.removeValue(forKey: task.httpHashKey)
        }
    }
    
    func delete<T: ZymeARequestType>(request: T) {
        let httpHashKey = transformHashKey(request: request)
        guard let task = downloadTasks[httpHashKey] as? ZymeDownloadTask<T> else {
            remove(httpHashKey: httpHashKey)
            return
        }
        task.requset.cancel()
        task.status = .suspend
        task.cancelOrCompletion = {
            self.remove(httpHashKey: httpHashKey)
        }
    }
    
    private func remove(httpHashKey: String){
        if let path = ZymeDownloadPlistManager.shared.downloadDataPlist[httpHashKey] as? String {
            let fileURL = ZymeDownloadPath.cacheDirectory.appendingPathComponent("data/\(path)")
            do {
                try FileManager.default.removeItem(at: fileURL)
                debugPrint("删除成功")
            } catch {
                debugPrint("删除失败")
            }
        }
        
        downloadTasks.removeValue(forKey: httpHashKey)
        ZymeDownloadPlistManager.shared.downloadDataPlist.removeObject(forKey: httpHashKey)
        ZymeDownloadPlistManager.shared.resumeDataPlist.removeObject(forKey: httpHashKey)
        ZymeDownloadPlistManager.shared.progressPlist.removeObject(forKey: httpHashKey)
        
        ZymeDownloadPlistManager.shared.downloadDataPlist.write(to: ZymeDownloadPath.downloadData.url, atomically: true)
        ZymeDownloadPlistManager.shared.resumeDataPlist.write(to: ZymeDownloadPath.resumeData.url, atomically: true)
        ZymeDownloadPlistManager.shared.progressPlist.write(to: ZymeDownloadPath.progress.url, atomically: true)
    }
    
    /// 下载完成路径
    func downloadFilePath<T: ZymeARequestType>(request: T) -> URL?{
        let httpHashKey = transformHashKey(request: request)
        guard let name = ZymeDownloadPlistManager.shared.downloadDataPlist[httpHashKey] as? String else {
            return nil
        }
        
        let fileURL = ZymeDownloadPath.downloadDirectory.appendingPathComponent(name)
        return fileURL
    }
    
    /// 下载百分比
    func downloadPercent<T: ZymeARequestType>(request: T) -> Double{
        let httpHashKey = transformHashKey(request: request)
        
        let percent = ZymeDownloadPlistManager.shared.progressPlist[httpHashKey] as? Double ?? 0
        return percent
    }
    
    func downloadStatus<T: ZymeARequestType>(request: T) -> ZymeDownloadTaskStatus {
        if downloadPercent(request: request) == 1 {
            return .completed
        }
        let httpHashKey = transformHashKey(request: request)

        guard let task = downloadTasks[httpHashKey] as? ZymeDownloadTask<T> else {
            return .suspend
        }
        return task.status
    }
    
    /// 下载进度
    @discardableResult
    func downloadProgress<T: ZymeARequestType>(request: T, progressClosure: @escaping ((Double)->())) -> ZymeDownloadTask<T>? {
        guard downloadPercent(request: request) < 1 else {
            return nil
        }
        let httpHashKey = transformHashKey(request: request)
        guard let task = downloadTasks[httpHashKey] as? ZymeDownloadTask<T> else {
            return nil
        }
        
        task.downloadProgress { (progress) in
            progressClosure(progress.fractionCompleted)
        }
        return task
    }
}

enum ZymeDownloadTaskStatus {
    case downloading
    case suspend
    case completed
}

class ZymeDownloadTask<T: ZymeARequestType>: Hashable {
    
    static func ==(lhs: ZymeDownloadTask<T>, rhs: ZymeDownloadTask<T>) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    var aRequest: T
    let requset: DownloadRequest
    let httpHashKey: String
    
    let queue = DispatchQueue(label: "com.download.zyme")
    
    var status: ZymeDownloadTaskStatus = .suspend
    
//    var hashValue: Int {
//        return httpHashKey.hashValue
//    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(httpHashKey)
//        hasher.combine(requestPolicy)
    }
    
    var cancelOrCompletion: (() -> Void)?
    
    init(_ r: T, url: URL, httpHashKey: String) {
        aRequest = r
        UIApplication.shared.isNetworkActivityIndicatorVisible = r.isOpenActivityIndicator
        self.httpHashKey = httpHashKey
        
        let resumeData = ZymeDownloadPlistManager.shared.resumeDataPlist[httpHashKey] as? Data
        
        let downloadFileDestination: DownloadRequest.DownloadFileDestination = { url, response in
            let fileURL = ZymeDownloadPath.downloadDirectory.appendingPathComponent("\(response.suggestedFilename!)")
            zymeNetDebugLog(fileURL.absoluteString)
            let downloadPlist = ZymeDownloadPlistManager.shared.downloadDataPlist
            downloadPlist[httpHashKey] = response.suggestedFilename!
            downloadPlist.write(to: ZymeDownloadPath.downloadData.url, atomically: true)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        if let resumeData = resumeData {
            requset = Alamofire.download(resumingWith: resumeData, to: downloadFileDestination)
        } else {
            requset = Alamofire.download(url, method: HTTPMethod(rawValue: r.method.rawValue)!, parameters: r.parameter, encoding: r.encoding, headers: r.headers, to: downloadFileDestination)
        }
        
        status = .downloading
    }
    
    @discardableResult
    func downloadProgress(progressClosure: @escaping ((Progress) -> Void)) -> ZymeDownloadTask{
        requset.downloadProgress(queue: queue) { (progress) in
            let progressPlist = ZymeDownloadPlistManager.shared.progressPlist
            progressPlist[self.httpHashKey] = progress.fractionCompleted
            progressPlist.write(to: ZymeDownloadPath.progress.url, atomically: true)
            DispatchQueue.main.sync {
                progressClosure(progress)

            }
        }
        return self
    }
    
    @discardableResult
    func responseData(completion: @escaping (ZymeResponseType<URL>) -> Void ) -> ZymeDownloadTask {
        requset.responseData(queue: queue) { (response) in
            let resumeDataPlist = ZymeDownloadPlistManager.shared.resumeDataPlist
            switch response.result {
            case .failure(let error):
                self.status = .suspend
                resumeDataPlist[self.httpHashKey] = response.resumeData
                resumeDataPlist.write(to: ZymeDownloadPath.resumeData.url, atomically: true)
                DispatchQueue.main.sync {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completion(ZymeResponseType.failure(error.localizedDescription))
                    self.cancelOrCompletion?()
                    self.cancelOrCompletion = nil

                }
            case .success(_):
                self.status = .completed
                let path = response.destinationURL!
                resumeDataPlist[self.httpHashKey] = nil
                resumeDataPlist.write(to: ZymeDownloadPath.resumeData.url, atomically: true)
                DispatchQueue.main.sync {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completion(ZymeResponseType.success(path))
                    self.cancelOrCompletion?()
                    self.cancelOrCompletion = nil
                }
            }
        }
        return self
    }
}

class ZymeDownloadResponse {
    
    let dataRequest: DownloadRequest
    let httpHashKey: String
    
    fileprivate var completionClosure: (()->Void)?
    
    init(dataRequest: DownloadRequest, httpHashKey: String, completionClosure: @escaping ()->Void) {
        self.dataRequest = dataRequest
        self.httpHashKey = httpHashKey
        self.completionClosure = completionClosure
    }
    
    @discardableResult
    func response(completion: @escaping (DefaultDownloadResponse) -> Void ) -> ZymeDownloadResponse {
        dataRequest.response(queue: nil) { (response) in
            completion(response)
            self.finished()
        }
        return self
    }
    
    @discardableResult
    func responseData(completion: @escaping (Alamofire.Result<Data>) -> Void ) -> ZymeDownloadResponse {
        dataRequest.responseData(queue: nil) { (response) in
            completion(response.result)
            self.finished()
        }
        return self
    }
    
    @discardableResult
    func responseJson(completion: @escaping (Alamofire.Result<Any>) -> Void ) -> ZymeDownloadResponse {
        dataRequest.responseJSON { (response) in
            completion(response.result)
            self.finished()
        }
        return self
    }
    
    @discardableResult
    func responseString(completion: @escaping (Alamofire.Result<String>) -> Void)  -> ZymeDownloadResponse {
        dataRequest.responseString(completionHandler: { response in
            completion(response.result)
            self.finished()
        })
        return self
    }
    
    private func finished(){
        completionClosure?()
        self.completionClosure = nil
    }
}


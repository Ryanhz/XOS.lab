//
//  HzyDownloadManager.swift
//  FETools
//
//  Created by hzf on 2017/11/3.
//  Copyright © 2017年 hzf. All rights reserved.
//

import Foundation
import Alamofire
fileprivate enum HzyDownloadPath: String {
    
    case progress = "progress.plist"
    case resumeData = "resumeData.plist"
    case downloadData = "downloadData.plist"
    
    var url: URL {
        return HzyDownloadPath.cacheDirectory.appendingPathComponent(self.rawValue)
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

final class HzyDownloadPlistManager {
    
   static let shared: HzyDownloadPlistManager = HzyDownloadPlistManager()
    private(set) var progressPlist: NSMutableDictionary = HzyDownloadPath.progress.pilst
    private(set) var resumeDataPlist: NSMutableDictionary = HzyDownloadPath.resumeData.pilst
    private(set) var downloadDataPlist: NSMutableDictionary = HzyDownloadPath.downloadData.pilst
    private init() {}
}

final class HzyDownloadManager: HzyAClient {
    
    var host: String {
        return HzyNet.hostType.host
    }
    
    static let `default` = HzyDownloadManager()
    
    fileprivate var downloadTasks = [String: Any]()
    
    @discardableResult
    func download<T: HzyARequestType>(_ r: T) -> HzyDownloadTask<T>{
        
        let url = URL(string: r.privateURL ?? host.appending(r.path))!
        let httpHashKey = transformHashKey(urlString: url.absoluteString, parameters: r.parameter)
        
        if let downloadTask = downloadTasks[httpHashKey] as? HzyDownloadTask<T> {
            return downloadTask
        } else {
            let downloadTask = HzyDownloadTask(r, url: url, httpHashKey: httpHashKey)
            downloadTasks[httpHashKey] = downloadTask
            downloadTask.cancelOrCompletion = {
                self.downloadTasks.removeValue(forKey: httpHashKey)
            }
            return downloadTask
        }
    }
    
    private init(){}
    
    func cancel<T: HzyARequestType>(request: T) {
        
        let httpHashKey = transformHashKey(request: request)
        
        guard let task = downloadTasks[httpHashKey] as? HzyDownloadTask<T> else {
            return
        }
        
        task.requset.cancel()
        task.cancelOrCompletion = {
            self.downloadTasks.removeValue(forKey: task.httpHashKey)
        }
    }
    
    func delete<T: HzyARequestType>(request: T) {
        let httpHashKey = transformHashKey(request: request)
        guard let task = downloadTasks[httpHashKey] as? HzyDownloadTask<T> else {
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
        if let path = HzyDownloadPlistManager.shared.downloadDataPlist[httpHashKey] as? String {
            let fileURL = HzyDownloadPath.cacheDirectory.appendingPathComponent("data/\(path)")
            do {
                try FileManager.default.removeItem(at: fileURL)
                debugPrint("删除成功")
            } catch {
                debugPrint("删除失败")
            }
        }
        
        downloadTasks.removeValue(forKey: httpHashKey)
        HzyDownloadPlistManager.shared.downloadDataPlist.removeObject(forKey: httpHashKey)
        HzyDownloadPlistManager.shared.resumeDataPlist.removeObject(forKey: httpHashKey)
        HzyDownloadPlistManager.shared.progressPlist.removeObject(forKey: httpHashKey)
        
        HzyDownloadPlistManager.shared.downloadDataPlist.write(to: HzyDownloadPath.downloadData.url, atomically: true)
        HzyDownloadPlistManager.shared.resumeDataPlist.write(to: HzyDownloadPath.resumeData.url, atomically: true)
        HzyDownloadPlistManager.shared.progressPlist.write(to: HzyDownloadPath.progress.url, atomically: true)
    }
    
    /// 下载完成路径
    func downloadFilePath<T: HzyARequestType>(request: T) -> URL?{
        let httpHashKey = transformHashKey(request: request)
        guard let name = HzyDownloadPlistManager.shared.downloadDataPlist[httpHashKey] as? String else {
            return nil
        }
        
        let fileURL = HzyDownloadPath.downloadDirectory.appendingPathComponent(name)
        return fileURL
    }
    
    /// 下载百分比
    func downloadPercent<T: HzyARequestType>(request: T) -> Double{
        let httpHashKey = transformHashKey(request: request)
        
        let percent = HzyDownloadPlistManager.shared.progressPlist[httpHashKey] as? Double ?? 0
        return percent
    }
    
    func downloadStatus<T: HzyARequestType>(request: T) -> HzyDownloadTaskStatus {
        if downloadPercent(request: request) == 1 {
            return .completed
        }
        let httpHashKey = transformHashKey(request: request)

        guard let task = downloadTasks[httpHashKey] as? HzyDownloadTask<T> else {
            return .suspend
        }
        return task.status
    }
    
    /// 下载进度
    @discardableResult
    func downloadProgress<T: HzyARequestType>(request: T, progressClosure: @escaping ((Double)->())) -> HzyDownloadTask<T>? {
        guard downloadPercent(request: request) < 1 else {
            return nil
        }
        let httpHashKey = transformHashKey(request: request)
        guard let task = downloadTasks[httpHashKey] as? HzyDownloadTask<T> else {
            return nil
        }
        
        task.downloadProgress { (progress) in
            progressClosure(progress.fractionCompleted)
        }
        return task
    }
}

enum HzyDownloadTaskStatus {
    case downloading
    case suspend
    case completed
}

class HzyDownloadTask<T: HzyARequestType>: Hashable {
    
    static func ==(lhs: HzyDownloadTask<T>, rhs: HzyDownloadTask<T>) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    var aRequest: T
    let requset: DownloadRequest
    let httpHashKey: String
    
    let queue = DispatchQueue(label: "com.download.hzy")
    
    var status: HzyDownloadTaskStatus = .suspend
    
    var hashValue: Int {
        return httpHashKey.hashValue
    }
    
    var cancelOrCompletion: (() -> Void)?
    
    init(_ r: T, url: URL, httpHashKey: String) {
        aRequest = r
        UIApplication.shared.isNetworkActivityIndicatorVisible = r.isOpenActivityIndicator
        self.httpHashKey = httpHashKey
        
        let resumeData = HzyDownloadPlistManager.shared.resumeDataPlist[httpHashKey] as? Data
        
        let downloadFileDestination: DownloadRequest.DownloadFileDestination = { url, response in
            let fileURL = HzyDownloadPath.downloadDirectory.appendingPathComponent("\(response.suggestedFilename!)")
            hzyNetDebugLog(fileURL.absoluteString)
            let downloadPlist = HzyDownloadPlistManager.shared.downloadDataPlist
            downloadPlist[httpHashKey] = response.suggestedFilename!
            downloadPlist.write(to: HzyDownloadPath.downloadData.url, atomically: true)
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
    func downloadProgress(progressClosure: @escaping ((Progress) -> Void)) -> HzyDownloadTask{
        requset.downloadProgress(queue: queue) { (progress) in
            let progressPlist = HzyDownloadPlistManager.shared.progressPlist
            progressPlist[self.httpHashKey] = progress.fractionCompleted
            progressPlist.write(to: HzyDownloadPath.progress.url, atomically: true)
            DispatchQueue.main.sync {
                progressClosure(progress)

            }
        }
        return self
    }
    
    @discardableResult
    func responseData(completion: @escaping (HzyResponseType<URL>) -> Void ) -> HzyDownloadTask {
        requset.responseData(queue: queue) { (response) in
            let resumeDataPlist = HzyDownloadPlistManager.shared.resumeDataPlist
            switch response.result {
            case .failure(let error):
                self.status = .suspend
                resumeDataPlist[self.httpHashKey] = response.resumeData
                resumeDataPlist.write(to: HzyDownloadPath.resumeData.url, atomically: true)
                DispatchQueue.main.sync {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completion(HzyResponseType.failure(error.localizedDescription))
                    self.cancelOrCompletion?()
                    self.cancelOrCompletion = nil

                }
            case .success(_):
                self.status = .completed
                let path = response.destinationURL!
                resumeDataPlist[self.httpHashKey] = nil
                resumeDataPlist.write(to: HzyDownloadPath.resumeData.url, atomically: true)
                DispatchQueue.main.sync {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completion(HzyResponseType.success(path))
                    self.cancelOrCompletion?()
                    self.cancelOrCompletion = nil
                }
            }
        }
        return self
    }
}

class HzyDownloadResponse {
    
    let dataRequest: DownloadRequest
    let httpHashKey: String
    
    fileprivate var completionClosure: (()->Void)?
    
    init(dataRequest: DownloadRequest, httpHashKey: String, completionClosure: @escaping ()->Void) {
        self.dataRequest = dataRequest
        self.httpHashKey = httpHashKey
        self.completionClosure = completionClosure
    }
    
    @discardableResult
    func response(completion: @escaping (DefaultDownloadResponse) -> Void ) -> HzyDownloadResponse {
        dataRequest.response(queue: nil) { (response) in
            completion(response)
            self.finished()
        }
        return self
    }
    
    @discardableResult
    func responseData(completion: @escaping (Alamofire.Result<Data>) -> Void ) -> HzyDownloadResponse {
        dataRequest.responseData(queue: nil) { (response) in
            completion(response.result)
            self.finished()
        }
        return self
    }
    
    @discardableResult
    func responseJson(completion: @escaping (Alamofire.Result<Any>) -> Void ) -> HzyDownloadResponse {
        dataRequest.responseJSON { (response) in
            completion(response.result)
            self.finished()
        }
        return self
    }
    
    @discardableResult
    func responseString(completion: @escaping (Alamofire.Result<String>) -> Void)  -> HzyDownloadResponse {
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


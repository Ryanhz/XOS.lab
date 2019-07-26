//
//  HzyNet.swift
//  FETools
//
//  Created by hzf on 2017/11/7.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit

func hzyNetDebugLog<T>(_ messsage : T, file : String = #file, funcName : String = #function, lineNum : Int = #line){
    #if DEBUG
        guard HzyNet.isDebugPrint else {
            return
        }
        let fileName = (file as NSString).lastPathComponent
        print("FE______________file:\(fileName),funcName:\(funcName) line:(\(lineNum)){\n  \(messsage)\n}")
    #endif
}

class HzyNet: HzyNetClosure {
    
    public enum HzyHostType {
        case develop
        case test
        case release
        
        var host: String {
            switch self {
            case .develop: return "http://101.231.43.155/Dida"
            case .release: return "http://139.196.232.47:8018"
            case .test: return "http://192.168.100.110:8018"
            }
        }
    }
    
    static var hostType: HzyHostType = .develop;
    
    static var defaultExcepotionDescription: String = "数据有些问题"
    
    public static var isDebugPrint: Bool = true
    
    static let requsetManager: HzyARequsetManager = HzyARequsetManager.shared
    
    static let downloadManager: HzyDownloadManager = HzyDownloadManager.default
}

extension HzyNet {
    
    class func cancel<T: HzyARequestType>(_ r: T)  {
        requsetManager.cancel(r)
    }
    
    class func removeHttpCache<T: HzyARequestType>(_ r: T) {
        requsetManager.removeHttpCache(r)
    }
    
    class func removeAllHttpCache() {
        requsetManager.removeAllHttpCache()
    }
    
    @discardableResult
    class func send<T: HzyARequestType>(_ r: T)-> HzyRequestTask<T> {
        if let netTool = HzyANetworkStatusTools.shared, !netTool.isReachable {
            hzyNetDebugLog("无网络")
        }
        return requsetManager.send(r)
    }
    
    class func upload<T: HzyAUpdataRequestType>(_ r: T, uploadProgress: ProgressClosure?, taskClosure: UploadTaskClosure<T>? = nil, parserClosure: @escaping ParserClosure<T>) {
        if let netTool = HzyANetworkStatusTools.shared, !netTool.isReachable {
            hzyNetDebugLog("无网络")
        }
        requsetManager.upload(r, uploadProgress: uploadProgress, taskClosure: taskClosure, parserClosure: parserClosure)
    }
}

extension HzyNet {
    
    @discardableResult
    class func download<T: HzyARequestType>(_ r: T) -> HzyDownloadTask<T> {
        if let netTool = HzyANetworkStatusTools.shared, !netTool.isReachable {
            hzyNetDebugLog("无网络")
        }
       return downloadManager.download(r)
    }
   
    class func downloadCancel<T: HzyARequestType>(request: T) {
        downloadManager.cancel(request: request)
    }
    
    class func downloadDelete<T: HzyARequestType>(request: T) {
       downloadManager.delete(request: request)
    }

    /// 下载完成路径
    class func downloadFilePath<T: HzyARequestType>(request: T) -> URL?{
        return downloadManager.downloadFilePath(request: request)
    }
    
    /// 下载百分比
    class func downloadPercent<T: HzyARequestType>(request: T) -> Double{
        return downloadManager.downloadPercent(request: request)
    }
    
    class func downloadStatus<T: HzyARequestType>(request: T) -> HzyDownloadTaskStatus {
        return downloadManager.downloadStatus(request: request)
    }
    
    /// 下载进度
    @discardableResult
    class func downloadProgress<T: HzyARequestType>(request: T, progressClosure: @escaping ((Double)->())) -> HzyDownloadTask<T>? {
        return downloadManager.downloadProgress(request: request, progressClosure: progressClosure)
    }
}

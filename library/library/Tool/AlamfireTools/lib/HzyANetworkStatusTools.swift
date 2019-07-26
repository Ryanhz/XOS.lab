//
//  FE_ANetworkStatusTools.swift
//  FETools
//
//  Created by hzf on 2017/11/2.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit
import Alamofire

public class HzyANetworkStatusTools {
    
    private static var _shared: HzyANetworkStatusTools?
    
    static var shared: HzyANetworkStatusTools? {
        
        if _shared == nil {
            _shared = HzyANetworkStatusTools()
        }
        return _shared
    }
    
    var reachabilityManager: NetworkReachabilityManager!
    
    var networkReachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus {
        return reachabilityManager.networkReachabilityStatus
    }
    
    var listener: NetworkReachabilityManager.Listener? {
        set {
            reachabilityManager.listener = newValue
        }
        get {
            return reachabilityManager.listener
        }
    }
    
    var isReachable: Bool {
        return  reachabilityManager.isReachable
    }
    
    var isReachableOnWWAN: Bool {
        return reachabilityManager.isReachableOnWWAN
    }
    
    var isReachableOnEthernetOrWiFi: Bool {
        return reachabilityManager.isReachableOnEthernetOrWiFi
    }
    
    deinit {
        stopListening()
    }
    
    private init?(host: String) {
        guard let manager = NetworkReachabilityManager(host: host)  else {
            return nil
        }
        self.reachabilityManager = manager
        
        listener = { (status) in
            switch status {
            case .notReachable:
                hzyNetDebugLog("无网络")
            case .reachable(let type):
                hzyNetDebugLog(type)
            case .unknown:
                hzyNetDebugLog("未知网络")
            }
        }
    }
    
    private init?() {
        guard let manager = NetworkReachabilityManager()  else {
            return nil
        }
        self.reachabilityManager = manager
        
        listener = { (status) in
            switch status {
            case .notReachable:
                hzyNetDebugLog("无网络")
            case .reachable(let type):
                hzyNetDebugLog(type)
            case .unknown:
                hzyNetDebugLog("未知网络")
            }
        }
    }
    
    func startListening()->Bool {
        return reachabilityManager.startListening()
    }
    
    func stopListening() {
        reachabilityManager.stopListening()
    }

}

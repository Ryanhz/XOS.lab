//
//  AppDelegete_Baidu.swift
//  library
//
//  Created by Ranger on 2018/5/17.
//  Copyright © 2018年 hzy. All rights reserved.
//

import Foundation
import HzyLib

extension AppDelegate {
    func configBaiduStat(){
        let stat = BaiduMobStat.default()
        stat?.start(withAppId: BaiduKey.statAppKey)
//        stat.
    }
    
    func configBaiduCrash(){
       CrabCrashReport.sharedInstance().initCrashReporter(withAppKey: BaiduKey.crashAppKey, andVersion: HzyAppInfo.appVersion, andChannel: "AppStore")
    }
    
    func configBaiduMap(){
        let ret = _mapManager.start(BaiduKey.ak, generalDelegate: self)
        if ret == false {
            print("manager start failed!")
        }
    }
}

extension AppDelegate: BMKGeneralDelegate{
    func onGetNetworkState(_ iError: Int32) {
        DLog(iError)
    }
    
    func onGetPermissionState(_ iError: Int32) {
        DLog(iError)
    }
}

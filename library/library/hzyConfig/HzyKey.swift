//
//  HzyKey.swift
//  hzy
//
//  Created by hzf on 2017/5/10.
//  Copyright © 2017年 hzy. All rights reserved.
//

import UIKit

struct SMSKey {
    static let appkey = "209af72ce814f"
    static let app_secrect = "a24af8392869530af65ef1797c57db0f"
}

struct UMKey {
    static let appkey = "598d2226677baa265a0000ed"
    static let app_secrect = "gwjbqguxnh6srocniua5nykwbttn6qm1"
    static let kdeviceToken_UserDefaultsKey = "kdeviceToken_UserDefaultsKey"
}

struct WechatKey {
    static let appkey = "wx772611cf96a341f3"
    static let app_secrect = "7f56e7a94a77ebcff6b3144feff814d5"
}

struct TF_RCAPP {
    static let APPKey = "p5tvi9dspmgc4"
    static let APPSecret = "k2mk9pIjc7Ws"
}

struct BaiduKey {
   static var ak: String {
        #if debug
            return "oXG2QGzcx1t1aneeqt6Tjb60MpV4Ub2G"
        #elseif release
            return "vjSFYztATA2Ni1BB6vZsQIbgku8uktfA"
        #else
            return "fQnYLvZkgtlQnG9U5UUDgfmdeGkcNEhC"
        #endif
    }
    
    static var statAppKey: String {
        return "e3427fe140"
    }
    
    static var crashAppKey: String {
        return "929b449720e04afd"
    }
}



/// kdeviceToken 推送token
var kdeviceToken = UserDefaults.standard.string(forKey: UMKey.kdeviceToken_UserDefaultsKey) ?? "" {
    didSet{
        UserDefaults.standard.set(kdeviceToken, forKey: UMKey.kdeviceToken_UserDefaultsKey)
    }
}

//
//  HzyApp.swift
//  library
//
//  Created by Ranger on 2018/5/4.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit

class HzyAppInfo {
    
    static let infoDictionary = Bundle.main.infoDictionary
    
    class var appName: String {
        return infoDictionary?["CFBundleDisplayName"] as? String ?? "?"
    }
    ///当前应用软件版本  比如：1.0.1
    static var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"

    }
    /// 当前应用版本号码   int类型
    static var appBuild: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "?"
    }
    //bundleIdentifier
    static var identifier: String  {
        return infoDictionary?["CFBundleIdentifier"] as? String ?? ""
    }
    static var currentLanguage: String {
        return NSLocale.preferredLanguages.first ?? ""
    }
}

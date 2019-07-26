//
//  FE_AUpdataParam.swift
//  Hzy
//
//  Created by hzf on 2017/5/11.
//  Copyright © 2017年 Hzy. All rights reserved.
//

import Foundation

enum HzyAUpdataMimeType: String {
    case mp4 = "audio/mp4", image = "image/jpeg"
}

protocol HzyAUpdataType {
    
    var fileURL: URL? { get }
    var data: Data? { get }
    var name: String { get }
    var fileName: String { get }
    var mimeType: HzyAUpdataMimeType { get }
}

struct HzyUpdata: HzyAUpdataType {
    
    var fileURL: URL? = nil
    var data: Data? = nil
    var fileName: String = "fileName"
    var name: String = "imageName"
    var mimeType: HzyAUpdataMimeType
    
    init(fileURL: URL, fileName: String = "fileName", name: String = "imageName", mimeType: HzyAUpdataMimeType) {
        self.fileName = fileName
        self.fileURL = fileURL
        self.name = name
        self.mimeType = mimeType
    }
    
    init(data: Data, fileName: String = "fileName", name: String = "imageName", mimeType: HzyAUpdataMimeType) {
        self.fileName = fileName
        self.data = data
        self.name = name
        self.mimeType = mimeType
    }
    
}

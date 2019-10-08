//
//  FE_AUpdataParam.swift
//  Zyme
//
//  Created by hzf on 2017/5/11.
//  Copyright © 2017年 Zyme. All rights reserved.
//

import Foundation

enum ZymeAUpdataMimeType: String {
    case mp4 = "audio/mp4", image = "image/jpeg"
}

protocol ZymeAUpdataType {
    
    var fileURL: URL? { get }
    var data: Data? { get }
    var name: String { get }
    var fileName: String { get }
    var mimeType: ZymeAUpdataMimeType { get }
}

struct ZymeUpdata: ZymeAUpdataType {
    
    var fileURL: URL? = nil
    var data: Data? = nil
    var fileName: String = "fileName"
    var name: String = "imageName"
    var mimeType: ZymeAUpdataMimeType
    
    init(fileURL: URL, fileName: String = "fileName", name: String = "imageName", mimeType: ZymeAUpdataMimeType) {
        self.fileName = fileName
        self.fileURL = fileURL
        self.name = name
        self.mimeType = mimeType
    }
    
    init(data: Data, fileName: String = "fileName", name: String = "imageName", mimeType: ZymeAUpdataMimeType) {
        self.fileName = fileName
        self.data = data
        self.name = name
        self.mimeType = mimeType
    }
    
}

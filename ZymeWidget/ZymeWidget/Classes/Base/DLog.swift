//
//  DLog.swift
//  SwfitTools
//
//  Created by zyme on 2017/3/21.
//  Copyright © 2017年 zyme. All rights reserved.
//

import Foundation

public func DLog<T>(_ messsage : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    //    file.lastPathComponent
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        
        print("Zyme______________file:\(fileName),funcName:\(funcName) line:(\(lineNum)){\n  \(messsage)\n}")
        
    #endif
}

public func DpLog<T>(_ message: T) {
    #if DEBUG
        print(message)
        
    #endif
}


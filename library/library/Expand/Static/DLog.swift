//
//  DLog.swift
//  SwfitTools
//
//  Created by hzf on 2017/3/21.
//  Copyright © 2017年 hzf. All rights reserved.
//

import Foundation

func DLog<T>(_ messsage : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    //    file.lastPathComponent
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        
        print("FE______________file:\(fileName),funcName:\(funcName) line:(\(lineNum)){\n  \(messsage)\n}")
        
    #endif
}

func DpLog<T>(_ message: T) {
    #if DEBUG
        print(message)
        
    #endif
}


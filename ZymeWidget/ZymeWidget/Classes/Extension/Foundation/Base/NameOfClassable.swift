//
//  NameOfClassable.swift
//  Zyme
//
//  Created by Zyme on 2017/12/7.
//  Copyright © 2017年 Zyme. All rights reserved.
//

import Foundation

public protocol ZymeNameOfClassable: class {
    static var nameOfClass: String {get}
    var nameOfClass: String {get}
}

public extension ZymeNameOfClassable {
    /*
     let classString = NSStringFromClass(self)
     return classString.components(separatedBy: ".").last ?? classString
    */
     static var nameOfClass: String { return String(describing: self) }
     var nameOfClass: String { return Self.nameOfClass }
}

extension NSObject: ZymeNameOfClassable {}


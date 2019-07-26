//
//  NameOfClassable.swift
//  DidaSystem
//
//  Created by hzf on 2017/12/7.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import Foundation

protocol HzyNameOfClassable: class {
    static var nameOfClass: String {get}
    var nameOfClass: String {get}
}

extension HzyNameOfClassable {
    /*
     let classString = NSStringFromClass(self)
     return classString.components(separatedBy: ".").last ?? classString
    */
    static var nameOfClass: String { return String(describing: self) }
    public var nameOfClass: String { return Self.nameOfClass }
}

extension NSObject: HzyNameOfClassable {}


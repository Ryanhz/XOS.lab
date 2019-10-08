//
//  ZymeNamespaceWrappable.swift
//  zyme
//
//  Created by Zyme on 2017/11/1.
//  Copyright © 2017年 Zyme. All rights reserved.
//

import UIKit

public class ZymeNamespaceWrapper<T>{

    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}

public protocol ZymeNamespaceWrappable {
    associatedtype WrapperType
    var zyme: WrapperType { get }
    static var zyme: WrapperType.Type { get }
}

public extension ZymeNamespaceWrappable {
    
    var zyme: ZymeNamespaceWrapper<Self> {
        return ZymeNamespaceWrapper(value: self)
    }
    
    static var zyme: ZymeNamespaceWrapper<Self>.Type {
        return ZymeNamespaceWrapper.self
    }
}

extension NSObject: ZymeNamespaceWrappable{}



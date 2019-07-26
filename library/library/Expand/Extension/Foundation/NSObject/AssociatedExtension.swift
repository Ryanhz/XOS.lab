//
//  associatedExtension.swift
//  FETools
//
//  Created by hzf on 2017/11/8.
//  Copyright © 2017年 hzf. All rights reserved.
//

import Foundation

protocol hzyAssociatedable: NSObjectProtocol {}

extension hzyAssociatedable where Self: NSObject{
    
    func associatedObject<ValueType: Any>(key: UnsafePointer<UInt8>, _ initialiser: ()-> ValueType) -> ValueType {
        if let associated = objc_getAssociatedObject(self, key) as? ValueType {
            return associated
        }
        
        let associated = initialiser()
        objc_setAssociatedObject(self, key, associated, .OBJC_ASSOCIATION_RETAIN)
        return associated
    }
    
    func associatedObject<ValueType: Any>(key: UnsafePointer<UInt8>) -> ValueType? {
        let associated = objc_getAssociatedObject(self, key) as? ValueType
        return associated
    }
    
    func associateSetObject<ValueType: Any>(key: UnsafePointer<UInt8>, value: ValueType?) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
    
    
    func associateSetUnownedObject<ValueType: Any>(key: UnsafePointer<UInt8>, value: ValueType?) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_ASSIGN)
    }
}

//TODO: ---Compiler bug
extension HzyNamespaceWrapper where T: NSObject {
    
    func associatedObject<ValueType: Any>(key: UnsafePointer<UInt8>, _ initialiser: ()-> ValueType) -> ValueType {
        return wrappedValue.associatedObject(key: key, initialiser)
    }
    
    func associatedObject<ValueType: Any>(key: UnsafePointer<UInt8>) -> ValueType? {
        return wrappedValue.associatedObject(key: key)
    }
    
    func associateSetObject<ValueType: Any>(key: UnsafePointer<UInt8>, value: ValueType?) {
        wrappedValue.associateSetObject(key: key, value: value)
    }
}




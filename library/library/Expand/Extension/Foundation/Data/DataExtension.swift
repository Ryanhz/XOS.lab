//
//  DataExtension.swift
//  Hzy
//
//  Created by hzf on 2017/11/17.
//  Copyright © 2017年 Hzy. All rights reserved.
//

import UIKit

extension Data {
    
    init<T>(from value: T) {
        var value = value
        //MemoryLayout<T>.size)
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }
    }
}

extension Data {
    
    init<T>(fromArray values: [T]) {
        var values = values
        self.init(buffer: UnsafeBufferPointer(start: &values, count: values.count))
    }
    
    func toArray<T>(type: T.Type) -> [T] {
        return self.withUnsafeBytes {
            [T](UnsafeBufferPointer(start: $0, count: self.count/MemoryLayout<T>.stride))
        }
    }
}

/// mark: -------
protocol DataConvertible {
    init?(data: Data)
    var data: Data { get }
}

extension DataConvertible {
    
    init?(data: Data) {
        guard data.count == MemoryLayout<Self>.size else { return nil }
        self = data.withUnsafeBytes { $0.pointee }
    }
    
    var data: Data {
        var value = self
        return Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
}


extension String: DataConvertible {
    init?(data: Data) {
        self.init(data: data, encoding: .utf8)
    }
    var data: Data {
        // Note: a conversion to UTF-8 cannot fail.
        return self.data(using: .utf8)!
    }
}

extension UInt16 : DataConvertible {

    init?(data: Data) {
        guard data.count == MemoryLayout<UInt16>.size else { return nil }
        self = data.withUnsafeBytes { $0.pointee }
    }

    var data: Data {
        //Acho que o padrao do IOS 'e LittleEndian, pois os bytes estavao ao contrario
        var value = CFSwapInt16HostToBig(self)
        return Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
}

extension Int: DataConvertible {}
extension Float: DataConvertible {}
extension Double: DataConvertible {}
extension UInt32: DataConvertible {}
extension UInt8: DataConvertible {}
//extension UInt16: DataConvertible { }

extension Data: HzyNamespaceWrappable {}

extension HzyNamespaceWrapper where T == Data {
    
}

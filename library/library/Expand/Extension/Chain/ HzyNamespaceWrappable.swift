//
//  FENamespaceWrappable.swift
//  FETools
//
//  Created by hzf on 2017/11/1.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit

public class HzyNamespaceWrapper<T>{

    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}

public protocol HzyNamespaceWrappable {
    associatedtype WrapperType
    var hzy: WrapperType { get }
    static var hzy: WrapperType.Type { get }
}

public extension HzyNamespaceWrappable {
    
    var hzy: HzyNamespaceWrapper<Self> {
        return HzyNamespaceWrapper(value: self)
    }
    
    static var hzy: HzyNamespaceWrapper<Self>.Type {
        return HzyNamespaceWrapper.self
    }
}

extension NSObject: HzyNamespaceWrappable{}
extension NSObject: hzyAssociatedable{}
extension UIView: HzyViewChainable {}


//
//  ZymeSuitSizeable.swift
//  Zyme
//
//  Created by Zyme on 2018/2/8.
//  Copyright © 2018年 Zyme. All rights reserved.
//

import Foundation
import UIKit

private let frameScale = UIScreen.main.bounds.width / 375

public protocol Convertingable {
    var cgFloat: CGFloat {get}
    var float: Float {get}
    var int: Int { get }
    var double: Double { get }
 
}

extension CGFloat: Convertingable {
    public var cgFloat: CGFloat {
        return  self
    }
    
    public var float: Float {
        return  Float(self)
    }
    
    public var int: Int {
      return  Int(self)
    }
    
    public var double: Double {
        return  Double(self)
    }
}

extension Int: Convertingable  {
    public var int: Int {
        return self
    }
    
    public var double: Double {
        return Double(self)
    }
    
   public var cgFloat: CGFloat{
        return CGFloat(self)
    }
    
    public var float: Float {
        return Float(self)
    }
}

extension Double: Convertingable  {
    public var int: Int {
        return Int(self)
    }
    
    public var double: Double {
        return self
    }
    
    public var float: Float {
        return Float(self)
    }
    
   public var cgFloat: CGFloat{
        return CGFloat(self)
    }
}

extension Float: Convertingable  {
    public var int: Int {
        return Int(self)
    }
    
    public var double: Double {
        return Double(self)
    }
    
    public var float: Float {
        return self
    }
    
   public var cgFloat: CGFloat{
        return CGFloat(self)
    }
}

public extension ZymeNamespaceWrapper where T == Int {
    var suitableScale: CGFloat {
        return frameScale * wrappedValue.cgFloat
    }
    var cgFloat: CGFloat{
        return wrappedValue.cgFloat
    }
    
    var float: Float {
        return Float(wrappedValue)
    }
}

public extension ZymeNamespaceWrapper where T == Double {
    var suitableScale: CGFloat {
        return frameScale * wrappedValue.cgFloat
    }
    var cgFloat: CGFloat{
        return wrappedValue.cgFloat
    }
}

public extension ZymeNamespaceWrapper where T == CGFloat {
    var suitableScale: CGFloat {
        return frameScale * wrappedValue
    }
    
    var intValue: Int {
        return wrappedValue.int
    }
}

public extension ZymeNamespaceWrapper where T == Float {
    var suitableScale: CGFloat {
        return frameScale * wrappedValue.cgFloat
    }
    var cgFloat: CGFloat{
        return wrappedValue.cgFloat
    }
}

extension Int: ZymeNamespaceWrappable{}
extension Double: ZymeNamespaceWrappable{}
extension CGFloat: ZymeNamespaceWrappable{}
extension Float: ZymeNamespaceWrappable{}





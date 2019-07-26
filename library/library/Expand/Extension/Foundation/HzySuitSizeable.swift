//
//  HzySuitSizeable.swift
//  DidaSystem
//
//  Created by hzf on 2018/2/8.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import Foundation
import UIKit

private let frameScale = HzySize.screenWidth / 375

protocol toCgFloatable {
    var cgFloat: CGFloat {get}
}

protocol toNumberable {
    var intValue: Int{get}
}

extension CGFloat: toNumberable {
    var intValue: Int {
        return Int(self)
    }
}

extension Int: toCgFloatable  {
    var cgFloat: CGFloat{
        return CGFloat(self)
    }
}

extension Double: toCgFloatable  {
    var cgFloat: CGFloat{
        return CGFloat(self)
    }
}

extension Float: toCgFloatable  {
    var cgFloat: CGFloat{
        return CGFloat(self)
    }
}

extension HzyNamespaceWrapper where T == Int {
    var suitableScale: CGFloat {
        return frameScale * CGFloat(wrappedValue)
    }
    var cgFloat: CGFloat{
        return CGFloat(wrappedValue)
    }
}

extension HzyNamespaceWrapper where T == Double {
    var suitableScale: CGFloat {
        return frameScale * CGFloat(wrappedValue)
    }
}

extension HzyNamespaceWrapper where T == CGFloat {
    var suitableScale: CGFloat {
        return frameScale * CGFloat(wrappedValue)
    }
}

extension HzyNamespaceWrapper where T == Float {
    var suitableScale: CGFloat {
        return frameScale * CGFloat(wrappedValue)
    }
}

extension Int: HzyNamespaceWrappable{}
extension Double: HzyNamespaceWrappable{}
extension CGFloat: HzyNamespaceWrappable{}
extension Float: HzyNamespaceWrappable{}





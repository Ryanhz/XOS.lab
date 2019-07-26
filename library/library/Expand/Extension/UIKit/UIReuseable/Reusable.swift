//
//  Reusable.swift
//  DidaSystem
//
//  Created by hzf on 2018/1/22.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import Foundation
import UIKit

protocol HzyReusable: HzyNameOfClassable {
    static var defaultIdentifier: String {get}
    var defaultIdentifier: String {get}
}

protocol HzyNibReusable: HzyReusable {
    static var nib: UINib { get }
}

extension HzyReusable {
    static var defaultIdentifier: String { return nameOfClass + ".fe." + "identifier" }
    var defaultIdentifier: String { return Self.defaultIdentifier }
}

extension HzyNibReusable {
    static var nib: UINib {
        return UINib(nibName: nameOfClass, bundle: nil)
    }
}

extension UITableViewCell: HzyNibReusable {}
extension UICollectionReusableView: HzyNibReusable {}
extension UITableViewHeaderFooterView: HzyNibReusable {}


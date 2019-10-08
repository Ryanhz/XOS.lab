//
//  Reusable.swift
//  zyme
//
//  Created by zyme on 2018/1/22.
//  Copyright © 2018年 zyme. All rights reserved.
//

import Foundation
import UIKit

protocol ZymeReusable: ZymeNameOfClassable {
    static var defaultIdentifier: String {get}
    var defaultIdentifier: String {get}
}

protocol ZymeNibReusable: ZymeReusable {
    static var nib: UINib { get }
}

extension ZymeReusable {
    static var defaultIdentifier: String { return nameOfClass + ".zyme." + "identifier" }
    var defaultIdentifier: String { return Self.defaultIdentifier }
}

extension ZymeNibReusable {
    static var nib: UINib {
        return UINib(nibName: nameOfClass, bundle: nil)
    }
}

extension UITableViewCell: ZymeNibReusable {}
extension UICollectionReusableView: ZymeNibReusable {}
extension UITableViewHeaderFooterView: ZymeNibReusable {}


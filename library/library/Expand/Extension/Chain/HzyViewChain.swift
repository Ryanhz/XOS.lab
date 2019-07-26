//
//  HzyUIViewChain.swift
//  FETools
//
//  Created by hzf on 2017/11/2.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit
import SnapKit

protocol HzyViewChainable {}

extension HzyViewChainable where Self: UIView {
    @discardableResult
    func addHere(toSuperview: UIView) -> Self {
        toSuperview.addSubview(self)
        return self
    }

    @discardableResult
    func layout(snapKitMaker: (ConstraintMaker) -> Void) -> Self {
        guard  let _ = self.superview  else {
            debugPrint("The parent view of \(self) cannot be empty")
            return self
        }
        self.snp.makeConstraints { (maker) in
            snapKitMaker(maker)
        }
        return self
    }

    @discardableResult
    func config(_ config: (Self) -> Void) -> Self {
        config(self)
        return self
    }
}




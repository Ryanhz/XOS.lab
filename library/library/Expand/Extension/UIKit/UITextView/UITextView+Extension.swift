//
//  UITextView+Extension.swift
//  TableContractManage
//
//  Created by hzf on 16/9/28.
//  Copyright © 2016年 hzf. All rights reserved.
//

import Foundation
import UIKit

private var kPlaceholderLabelPointer: UInt8 = 0

extension UITextView {
	var placeHolderTextView: UITextView? {
		get {
			return objc_getAssociatedObject(self, &kPlaceholderLabelPointer) as?UITextView
		}
        
		set {
			objc_setAssociatedObject(self, &kPlaceholderLabelPointer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	func setPlaceHolder(_ placeHolderStr: String?) {

		if placeHolderTextView == nil {
			placeHolderTextView = UITextView(frame: self.bounds)
            DLog(self.bounds)
			placeHolderTextView?.isUserInteractionEnabled = false

			placeHolderTextView?.text = placeHolderStr
			placeHolderTextView?.textColor = UIColor.gray
            placeHolderTextView?.backgroundColor = UIColor.clear

			self.insertSubview(placeHolderTextView!, at: 0)
		}
	}
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        placeHolderTextView?.frame = self.bounds
        placeHolderTextView?.font = self.font
    }

	open override func willMove(toSuperview newSuperview: UIView?) {

        if newSuperview == nil {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        }else {
            NotificationCenter.default.addObserver(self,selector: #selector(UITextView.didChange(_:)),name: NSNotification.Name.UITextViewTextDidChange,object: nil)
        }
	}

    @objc func didChange (_ notification: Notification) {

		guard placeHolderTextView != nil else {
			return
		}
        let obj = notification.object  as AnyObject
		if obj === self {
			if text.isEmpty {
                placeHolderTextView!.isHidden = false
			} else {
				placeHolderTextView!.isHidden = true
			}
		}
	}
}

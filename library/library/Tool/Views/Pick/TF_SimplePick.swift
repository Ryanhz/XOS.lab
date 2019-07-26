//
//  TF_SexPick.swift
//  Hzy
//
//  Created by hzf on 2017/5/31.
//  Copyright © 2017年 Hzy. All rights reserved.
//

import UIKit

class TF_SimplePick: UIView, HzyPickerViewable {
     var selectedData: Any? {
        return selectedItem
    }
    
    var pickView: UIPickerView!
    fileprivate var selectedItem: HzyPickDataable?
    var selectedBlock: ((_ model: HzyPickDataable?) ->Void)!
    
    var dataSource: [HzyPickDataable]? {
        willSet{
            guard let source = newValue, source.count > 0 else {
                return
            }
            selectedItem = source[0]
        }
    }
    
    deinit {
//        DLog("_____")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pickView = UIPickerView()
        pickView.delegate = self
        pickView.dataSource = self
        self.addSubview(pickView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pickView.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private typealias delegateExtension = TF_SimplePick

extension delegateExtension:  UIPickerViewDelegate, UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataSource?[row].pickTitle
    }
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?  {
//        return
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = dataSource?[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource?.count ?? 0
    }
}

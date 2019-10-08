//
//  TF_DatePick.swift
//  Zyme
//
//  Created by hzf on 2017/5/15.
//  Copyright © 2017年 Zyme. All rights reserved.
//

import UIKit

class TF_DatePickerView: UIView, ZymePickerViewable{
    var selectedData: Any? {
        return formatter.string(from: date)
    }
    
    var dateFormat = "yyyy-MM-dd" {
        didSet{
             formatter.dateFormat = dateFormat
        }
    }
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.calendar = self.calendar
        return formatter
    }()
  
    var calendar: Calendar = Calendar(identifier: .gregorian){
        didSet{
            formatter.calendar = calendar
        }
    }
    
    var contentView: UIView = UIView()
    var datePicker: UIDatePicker = UIDatePicker()
    var date: Date = Date()
    var datePickerMode: UIDatePicker.Mode = .date {
        didSet{
            datePicker.datePickerMode = datePickerMode
        }
    }
    
    @objc func datePickViewValueChange(_ datePicker: UIDatePicker) {
        date = datePicker.date
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        datePicker.locale = Locale(identifier: "zh")
        datePicker.datePickerMode = datePickerMode
        datePicker.date = date
        datePicker.addTarget(self, action: #selector(datePickViewValueChange(_:)), for: .valueChanged)
        self.addSubview(contentView)
        contentView.addSubview(datePicker)
        contentView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self)
        }
        datePicker.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.contentView)
        }
    }
}


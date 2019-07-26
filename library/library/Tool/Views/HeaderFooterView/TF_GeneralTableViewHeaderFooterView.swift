//
//  TF_GeneralTableViewHeaderFooterView.swift
//  DidaSystem
//
//  Created by hzf on 2018/1/8.
//  Copyright © 2018年 feidSoft. All rights reserved.
//

import UIKit

class TF_GeneralTableViewHeaderFooterView: UITableViewHeaderFooterView {

    var titleleft: CGFloat = 15
    var titleTop: CGFloat = 12
    var titleHeight: CGFloat = 12
  
    var titleLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel()
        titleLabel?.text = ""
        titleLabel?.textColor = BaseColor.gray_7c7e86
        titleLabel?.font = UIFont.systemFont(ofSize: 11)
        self.contentView.addSubview(titleLabel)
        self.contentView.backgroundColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame = CGRect(x: titleleft, y: self.height-titleTop, width: self.width - 2 * titleleft, height: titleHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

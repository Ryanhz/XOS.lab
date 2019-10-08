//
//  TF_CommonPickController.swift
//  Zyme
//
//  Created by hzf on 2017/5/31.
//  Copyright © 2017年 Zyme. All rights reserved.
//

import UIKit

protocol ZymePickerViewable {
    var selectedData: Any? { get }
}

class ZymePickController: UIViewController {
    
    var topTitle = ""
    fileprivate var defautHeight: CGFloat = 240
    fileprivate var coverView: UIView!
    fileprivate var topContentView: UIView!
    fileprivate var titleLabel: UILabel!
    fileprivate var chooseBtn: UIButton!
    fileprivate var cancelBtn: UIButton!
    fileprivate var line: UIView!
    fileprivate var pickView:  ZymePickerViewable!
    fileprivate var contentView: UIView!
    
    fileprivate var selectedBlock:  ((Any?)->Void)!
    
//    fileprivate lazy var popoverAnimator: ZymePopoverAnimator = ZymePopoverAnimator {[weak self] (presented) in
//    }
    
    deinit {
        DLog("_____")
    }
    
    init<T: ZymePickerViewable>(_ pickView: T, selectedBlock: @escaping (Any?)->Void) where T: UIView {
        
        super.init(nibName: nil, bundle: nil)
    
//        defautHeight += UIScreen.zyme.extraBottom

//        self.modalPresentationStyle = .custom
//        self.transitioningDelegate = popoverAnimator
//        self.selectedBlock = selectedBlock
//        self.pickView = pickView
//        let screenBounds = UIScreen.main.bounds
//        popoverAnimator.presentedFrame = CGRect(x: 0, y: screenBounds.height - defautHeight, width: UIScreen.width, height: defautHeight)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    @objc fileprivate func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func chooseAction() {
        self.dismiss(animated: true, completion: nil)
        selectedBlock(pickView.selectedData)
    }
    
    fileprivate func setupSubviews() {
        self.view.backgroundColor = UIColor.red
        contentView = UIView()
        contentView.backgroundColor = UIColor.white
        
        topContentView = UIView()
        topContentView.backgroundColor = UIColor.white
        
        titleLabel = UILabel()
        titleLabel.text = topTitle
    
        cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.gray, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        chooseBtn = UIButton()
        chooseBtn.setTitleColor(UIColor.blue, for: .normal)
        chooseBtn.setTitle("确定", for: .normal)
        chooseBtn.addTarget(self, action: #selector(chooseAction), for: .touchUpInside)
        line = UIView()
        line.backgroundColor = UIColor(rgba: 0xffeeeeee)
        
        self.view.addSubview(contentView)
        self.contentView.addSubview(topContentView)
        self.topContentView.addSubview(titleLabel)
        self.topContentView.addSubview(cancelBtn)
        self.topContentView.addSubview(chooseBtn)
        self.contentView.addSubview(pickView as! UIView)
        self.topContentView.addSubview(line)
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(defautHeight)
            make.bottom.equalTo(view)
        }
        
        topContentView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(contentView)
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.center.equalTo(topContentView)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.centerY.equalTo(topContentView)
            make.width.equalTo(80)
            make.height.equalTo(44)
        }
        
        chooseBtn.snp.makeConstraints { (make) in
            make.right.centerY.equalTo(topContentView)
            make.width.equalTo(80)
            make.height.equalTo(44)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(topContentView)
            make.height.equalTo(1)
        }
     
        
        (pickView as! UIView).snp.makeConstraints { (make) in
            make.top.equalTo(topContentView.snp.bottom)
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-UIScreen.zyme.extraBottom)
        }
    }
}





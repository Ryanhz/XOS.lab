//
//  TF_PickViewController.swift
//  thunFeidOA
//
//  Created by hzf on 2017/4/6.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit


protocol ZymePickDataable {
    var pickTitle: String{get}
}


class TF_PickViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    fileprivate var defautHeight: CGFloat = 240
    fileprivate var coverView: UIView!
    fileprivate var topContentView: UIView!
    fileprivate var chooseBtn: UIButton!
    fileprivate var cancelBtn: UIButton!
    fileprivate var line: UIView!
    fileprivate var pickView: UIPickerView!
    fileprivate var contentView: UIView!
    fileprivate var selectedItem: ZymePickDataable?
    var selectedBlock: ((_ model: ZymePickDataable?) ->Void)?
    
    var dataSource: [ZymePickDataable]? {
        willSet{
            guard let source = newValue, source.count > 0 else {
                return
            }
            selectedItem = source[0]
        }
    }
    
//    fileprivate lazy var popoverAnimator: ZymePopoverAnimator = ZymePopoverAnimator {[weak self] (presented) in
//        if !presented{
//            self?.selectedBlock?(nil)
//            self?.selectedBlock = nil
//        }
//    }
    
    init(selectedBlock: @escaping (_ model: ZymePickDataable?)->Void) {
        super.init(nibName: nil, bundle: nil)
        self.selectedBlock = selectedBlock
        self.modalPresentationStyle = .custom
    
//        self.transitioningDelegate = popoverAnimator
        let screenBounds = UIScreen.main.bounds
//        popoverAnimator.presentedFrame = CGRect(x: 0, y: screenBounds.height - defautHeight, width: UIScreen.width, height: defautHeight)
    }
//    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func cancelAction() {
        self.dismiss(animated: true) {
            self.selectedBlock = nil
        }
    }
    
   @objc fileprivate func chooseAction() {
        selectedBlock?(selectedItem!)
        self.dismiss(animated: true) {
            self.selectedBlock = nil
        }
    }
    
   fileprivate func setupSubviews() {
        self.view.backgroundColor = UIColor.red
        contentView = UIView()
        contentView.backgroundColor = UIColor.white
        topContentView = UIView()
        topContentView.backgroundColor = UIColor.white
        
        cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor(hex: "#FF28A0FF"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        chooseBtn = UIButton()
        chooseBtn.setTitleColor(UIColor.red, for: .normal)
        chooseBtn.setTitle("确定", for: .normal)
        chooseBtn.addTarget(self, action: #selector(chooseAction), for: .touchUpInside)
        line = UIView()
        line.backgroundColor = UIColor(hex: "#ffeeeeee")
        
        pickView = UIPickerView()
        pickView.delegate = self
        pickView.dataSource = self
        
        self.view.addSubview(contentView)
        self.contentView.addSubview(topContentView)
        self.contentView.addSubview(pickView)
        self.topContentView.addSubview(cancelBtn)
        self.topContentView.addSubview(chooseBtn)
        self.topContentView.addSubview(line)
        
        weak var weakSelf = self
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalTo((weakSelf!.view)!)
            make.height.equalTo(weakSelf!.defautHeight)
            make.bottom.equalTo(weakSelf!.view)
        }
        
        topContentView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo((weakSelf!.contentView))
            make.height.equalTo(50)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.centerY.equalTo(weakSelf!.topContentView)
            make.width.equalTo(80)
            make.height.equalTo(44)
        }
        
        chooseBtn.snp.makeConstraints { (make) in
            make.right.centerY.equalTo(weakSelf!.topContentView)
            make.width.equalTo(80)
            make.height.equalTo(44)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo((weakSelf?.topContentView)!)
            make.height.equalTo(1)
        }
        
        pickView.snp.makeConstraints { (make) in
            make.top.equalTo((weakSelf?.topContentView.snp.bottom)!)
            make.left.right.bottom.equalTo(weakSelf!.contentView)
        }
    }
}

private typealias delegateExtension = TF_PickViewController

extension delegateExtension {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataSource?[row].pickTitle
    }
    
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



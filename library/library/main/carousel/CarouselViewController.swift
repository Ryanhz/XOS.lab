//
//  CarouselViewController.swift
//  library
//
//  Created by hzf on 2018/9/10.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit

struct HzyCarouselSoure: HzyCarouselSoureAble {
    var title: String  {
        return text
    }
    var text: String
}

class CarouselViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        var list: [HzyCarouselSoureAble] = []
        for i in 0...5 {
            let data =  HzyCarouselSoure(text: "\(i)---------------")
            list.append(data)
        }
        let carouseView = HzyCarouselView()
        
        carouseView.dataSource = list
        
        self.view.addSubview(carouseView)
        carouseView.backgroundColor = UIColor.yellow
        carouseView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.height.equalTo(60)
            maker.width.equalTo(300)
        }
        
        for i in 6...10 {
            let data =  HzyCarouselSoure(text: "\(i)---------------")
            list.append(data)
        }
        let carouseView2 = HzyCarouselView()
        carouseView2.scrollDirection = .horizontal
        carouseView2.tag = 2000
        carouseView2.dataSource = list
        
        self.view.addSubview(carouseView2)
        carouseView2.backgroundColor = UIColor.yellow
        carouseView2.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.height.equalTo(150)
            maker.width.equalTo(60)
        }
        
        let btn = UIButton()
        btn.setTitle("reset 2", for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(action), for: .touchUpInside)
        
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(120)
            maker.height.equalTo(50)
            maker.top.equalTo(70)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func action() {
        let re: HzyCarouselView  = self.view.viewWithTag(2000) as!HzyCarouselView
         var list: [HzyCarouselSoureAble] = []
        
        for i in 6...10 {
            let data =  HzyCarouselSoure(text: "\(i)---------------")
            list.append(data)
        }
        
        re.dataSource = list
    }
}

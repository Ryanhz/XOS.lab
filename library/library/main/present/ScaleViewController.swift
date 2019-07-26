//
//  ScaleViewController.swift
//  library
//
//  Created by Ranger on 2018/5/23.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit
import HzyLib
class ScaleViewController: UIViewController, HzyPushPopScaleAnimatedTransitioningable {

    var imageView: UIImageView = UIImageView()
    
    var transitionAnimationTargetView: UIView? {
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "Ex.jpg")
        imageView.frame = CGRect(x: 0, y: UIScreen.hzy.navHeitht, width: self.view.width, height: 200)
        self.view.addSubview(imageView)
        self.view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

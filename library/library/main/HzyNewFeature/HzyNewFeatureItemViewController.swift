//
//  HzyNewFeatureItemViewController.swift
//  library
//
//  Created by Ranger on 2018/5/14.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit

class HzyNewFeatureItemViewController: UIViewController, NewFeaturSubViewItemable{

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var enterBtn: UIButton!
    
    var isHidenEnterBtn: Bool = true
    
    var imageName: String = ""
    
    var completeBlock: (()->Void)?
    
    var newFeatureView: UIView {
        return self.view
    }
    
    class func items(imageNames: String...)->[HzyNewFeatureItemViewController]{
        var items: [HzyNewFeatureItemViewController] = []
        for (index, imageName) in imageNames.enumerated() {
            let itemVC = HzyNewFeatureItemViewController.initFromStoryBorad(storyboardName: MyEnum.StoryboardName.other.rawValue)
            itemVC.imageName = imageName
            itemVC.isHidenEnterBtn = index < imageNames.count - 1
            items.append(itemVC)
        }
        return items
    }
    
    func setCompleteBlock(block: @escaping () -> Void) {
        completeBlock = block
    }
    
    func hzyDidEnterForeground() {
        UIView.animate(withDuration: 0.5) {
            self.imageView.transform = CGAffineTransform.identity
        }
    }
    
    func hzyDidEnterBackGround() {
        UIView.animate(withDuration: 0.5) {
            self.imageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: imageName)
        enterBtn.isHidden = isHidenEnterBtn
        self.imageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
    }

    @IBAction func enterClickAction(_ sender: Any) {
        completeBlock?()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

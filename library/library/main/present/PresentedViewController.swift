//
//  PresentedViewController.swift
//  library
//
//  Created by Ranger on 2018/5/18.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit

class PresentedViewController: UIViewController, HzyTransitioningDelegateable {
    
    var portrait: CGRect?
    var landScape: CGRect?
    var maskColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.randomColor()
        let view = UIView()
        view.backgroundColor = UIColor.randomColor()
        view.frame = self.view.bounds
        view.y = self.view.height/2
        view.height = self.view.height/2
        self.view.addSubview(view)
        
        view.hzy.click { [unowned self] in
            self.push()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func push(){
        self.navigationController?.pushViewController(PresentedViewController(), animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
 
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

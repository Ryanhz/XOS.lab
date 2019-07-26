//
//  ReactViewController.swift
//  library
//
//  Created by Ranger on 2018/6/14.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit

class ReactViewController: UIViewController {

    
    #if debug
    let jsCodeLocation = URL(string: "http://localhost:8081/index.bundle?platform=ios")

    #else
    let jsCodeLocation = Bundle.main.url(forResource: "main", withExtension: "jsbundle")
    #endif
    
    let mockData:NSDictionary = ["scores":
        [
            ["name":"Alex", "value":"42"],
            ["name":"Joel", "value":"10"]
        ]
    ]
    
    override func loadView() {
        self.view = RCTRootView(bundleURL: jsCodeLocation,
                                moduleName: "RNHighScores",
                                initialProperties: mockData as [NSObject : AnyObject],
                                launchOptions: nil)
    }
    
    var rootView: RCTRootView {
        return self.view as! RCTRootView;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

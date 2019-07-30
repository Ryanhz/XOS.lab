//
//  AppDelegate.swift
//  laboratory
//
//  Created by hzf on 2019/7/26.
//  Copyright © 2019 zyme. All rights reserved.
//

import UIKit
import Flutter
import flutter_boost
import Zyme

@UIApplicationMain
class AppDelegate:  FLBFlutterAppDelegate  {

//    var window: UIWindow?
    var rootStack: ZRootNavigationController {
        get{
           return ZRootNavigationController.rootNavigation
        }
    }
    var flutterRouter = FlutterRouter()

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DLog(UIDevice.zyme.readMacAddress())
        DLog(UIDevice.zyme.GetIPAddresses())
        
        FlutterBoostPlugin.sharedInstance()?.startFlutter(with: flutterRouter, onStart: { (vc) in
            
        })
        
        #if DEBUG
        DLog("Debug")
        #elseif AdHoc
        print("AdHoc")
        #else
        print("Release")
        #endif
        
        self.window.rootViewController = rootStack
        
        if isShowNewFeature(){
            
            let newFeature = instantiateViewController(true)
            newFeature.completeBlock = { [unowned self] in
                self.showMain()
            }
            rootStack.pushViewController(newFeature, animated: false)
//            rootStack.present(newFeature, animated: false, completion: nil)
        } else {
//            setMainRoot()
        }
        
        return true
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    func instantiateViewController(_ animate: Bool = true) ->ZymeNewFeatureViewController{
        if animate {
            let items = ZymeNewFeatureCustomItem.items(imageNames: "1","2","3", "4")
            return ZymeNewFeatureViewController(items)
        } else {
            return ZymeNewFeatureViewController(["1","2","3", "4"])
        }
    }
    
    func isShowNewFeature()-> Bool{
        return false
    }
    
    func showMain(animated: Bool = false){
        rootStack.popViewController(animated: animated)
    }
    
//
//    override func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    }
//
//    override func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//
//    override func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//
//    override func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//
//    override func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }


}


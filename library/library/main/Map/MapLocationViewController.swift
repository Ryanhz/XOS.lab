//
//  MapLocationViewController.swift
//  library
//
//  Created by Ranger on 2018/5/15.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit

class MapLocationViewController: UIViewController {

    enum LocationType {
        case once
        case updatingLocation
//        case background
    }
    
    var textView: UITextView = UITextView()
    
    var locationType: LocationType = .once
    
    var locationManger: BMKLocationManager = BMKLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch locationType {
        case .once:
            requestOnce()
        case .updatingLocation:
            startUpdating()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        switch locationType {
        case .once:
            requestOnce()
        case .updatingLocation:
            stopUpdating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        BMKLocationAuth()
        self.navigationItem.title = "定位"
        self.view.backgroundColor = UIColor.white
        textView.isEditable = false
        textView.layer.borderColor = UIColor.darkText.cgColor
        textView.layer.borderWidth = 1
        
        self.view.addSubview(textView)

        textView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview().offset(15)
            maker.right.equalToSuperview().offset(-15)
            maker.bottom.equalToSuperview().multipliedBy(0.5)
        }
        
        BMKLocationAuth.sharedInstance().checkPermision(withKey: BaiduKey.ak, authDelegate: self)
        configManager()

    }
    
    func configManager(){
        //设置delegate
        locationManger.delegate = self
        //设置返回位置的坐标系类型
        locationManger.coordinateType = .BMK09LL
        //设置距离过滤参数
        locationManger.distanceFilter = kCLDistanceFilterNone
        //设置预期精度参数
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        //设置应用位置类型
        locationManger.activityType = .automotiveNavigation
        //设置是否自动停止位置更新 指定定位是否会被系统自动暂停。默认为NO。是否允许后台定位。默认为NO。只在iOS 9.0及之后起作用。设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
        locationManger.pausesLocationUpdatesAutomatically = false
        //设置是否允许后台定位
        locationManger.allowsBackgroundLocationUpdates = true
        //设置位置获取超时时间
        locationManger.locationTimeout = 10
        //设置获取地址信息超时时间
        locationManger.reGeocodeTimeout = 10
        
    }
    
    func printToTextView(_ info: String?) {
        
        guard let info = info else {
            return
        }
        
        let line = Date().stringWithyyyyMMddHHmmssByLine + "  : \n\t" +  info + "\n\n"
        textView.textStorage.mutableString.append(line)
        let allStrCount = textView.text.count
        
        textView.scrollRangeToVisible(NSRange.init(location: 0, length: allStrCount))
//        textView.scrollRectToVisible(CGRect(x:0, y:textView.contentSize.height - 15, width: textView.contentSize.width, height:10), animated: true)
    }
    
    // MARK: ---------单次获取定位
    func requestOnce(){
        self.locationManger.requestLocation(withReGeocode: true, withNetworkState: true) {[weak self] (loc, nState, err) in
            
            self?.printToTextView("loc: " + (loc?.location?.description ?? "nil") + (loc?.rgcData?.description ?? "nil") )
            self?.printToTextView(nState.rawValue.description)
            self?.printToTextView(err.debugDescription)
        }
    }
    
    //MAKR: ----------开启持续定位
    func startUpdating(){
//        locationManger.startUpdatingLocation()
        
        //如果需要持续定位返回地址信息（需要联网），请设置如下：
        locationManger.locatingWithReGeocode = true
        locationManger.startUpdatingLocation()
    }
    
    func stopUpdating(){
        self.locationManger.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MapLocationViewController: BMKLocationManagerDelegate {
  
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate heading: CLHeading?) {
        printToTextView("didUpdate heading:"+heading.debugDescription)
    }
    
    func bmkLocationManager(_ manager: BMKLocationManager, didFailWithError error: Error?) {
        printToTextView("didFailWithError:"+error.debugDescription)
    }
    
    func bmkLocationManagerShouldDisplayHeadingCalibration(_ manager: BMKLocationManager) -> Bool {
        return true
    }
    
    func bmkLocationManager(_ manager: BMKLocationManager, didChange status: CLAuthorizationStatus) {
        printToTextView("didChange status: CLAuthorizationStatus:"+status.rawValue.description)
    }
    
    ///接收位置更新
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
        
        printToTextView("didUpdate location: error:" + error.debugDescription)
        
        printToTextView("didUpdate location: " + (location?.location?.description ?? "") + (location?.rgcData?.description ?? "nil"))
    }
    
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate state: BMKLocationNetworkState, orError error: Error?) {
        printToTextView("didUpdate state: BMKLocationNetworkStat: " + state.rawValue.description)
        printToTextView("didUpdate state: BMKLocationNetworkStat:" + error.debugDescription)
    }
}

extension MapLocationViewController: BMKLocationAuthDelegate {
    func onCheckPermissionState(_ iError: BMKLocationAuthErrorCode) {
        printToTextView(iError.rawValue.description)
    }
}

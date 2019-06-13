//
//  ViewController.swift
//  BaiDuMapTest
//
//  Created by zl on 2019/5/29.
//  Copyright © 2019 ZHUNJIEE. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, BMKMapViewDelegate, BMKLocationManagerDelegate {
    var userLocation: BMKUserLocation = BMKUserLocation()
    
    // MARK: 初始化
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "百度地图"
        setupNavigationItem()

        // 显示地图
        view.addSubview(mapView)
        // 开启定位
        locationManager.startUpdatingLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        mapView.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.viewWillDisappear()
    }
    
    // MARK: BMKLocationManagerDelegate
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
        if error != nil {
            print("定位失败")
        }
        if location != nil {
            if let loc = location?.location {
                userLocation.location = loc
                print("LOC = \(loc)")
                
                // 地图显示到当前的位置
                mapView.updateLocationData(userLocation)
                mapView.setCenter(userLocation.location.coordinate, animated: true)
                manager.stopUpdatingLocation()
            }
        }
        if location?.rgcData != nil {
            if let description = location?.rgcData?.description {
                print("rgc = \(description)")
            }
        }
    }
    
    // MARK: 懒加载
    lazy var mapView: BMKMapView = {
        // 创建地图
        let mapView = BMKMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.zoomLevel = 18 // 设置缩放等级
        mapView.showMapScaleBar = true // 显示比例尺
        mapView.showsUserLocation = true // 显示用户位置图标
        mapView.userTrackingMode = BMKUserTrackingModeNone  // 设置定位图标显示效果
        return mapView
    }()
    
    lazy var locationManager: BMKLocationManager = {
        let manager = BMKLocationManager()
        manager.delegate = self
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
        manager.coordinateType = BMKLocationCoordinateType.BMK09LL  // 不设置会导致定位不准
        //设定定位精度，默认为 kCLLocationAccuracyBest
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        manager.activityType = CLActivityType.automotiveNavigation
        return manager
    }()
}


// MARK: - 界面UI
extension HomeViewController {
    /// 设置导航栏左右按钮
    fileprivate func setupNavigationItem() {
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: "wode"), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        leftBtn.backgroundColor = MyColor(246, 246, 246)
//        leftBtn.imageEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 10)
//        leftBtn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        leftBtn.addTarget(self, action: #selector(mineButtonDidClick(btn:)), for: .touchUpInside)
    }
}


// MARK: - 事件监听函数
extension HomeViewController {
    @objc func mineButtonDidClick(btn: UIButton) {
        
    }
}


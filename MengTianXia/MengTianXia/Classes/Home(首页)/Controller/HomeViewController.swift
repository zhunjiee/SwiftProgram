//
//  HomeViewController.swift
//  MengTianXia
//
//  Created by zl on 2019/7/25.
//  Copyright © 2019 LuMeng. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class HomeViewController: BaseViewController {
    
    // MARK: -  懒加载
    
    // 搜索框
    fileprivate lazy var searchBar: BWSearchBarView = {
        let searchBar = BWSearchBarView(frame: CGRect(x: 0, y: 0, width: navigationItem.titleView?.frame.width ?? 1000, height: 44))
        searchBar.searchField.delegate = self
        return searchBar
    }()
    
    // 城市选择按钮
    fileprivate lazy var cityButton: UIButton = {
        let cityButton = UIButton(type: .custom)
        cityButton.setTitle("临沂", for: .normal)
        cityButton.setTitleColor(BlackTextColor, for: .normal)
        cityButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cityButton.sizeToFit()
        cityButton.addTarget(self, action: #selector(cityButtonDidCilck(button:)), for: .touchUpInside)
        return cityButton
    }()
    
    
    // MARK: -  生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BWUserDefaults.shareInstance.setUserToken(token: "f36fa865-ee3c-4f8d-805a-5a3ee42c0e8d")
        
        self.view.tag = 10086
        view.backgroundColor = UIColor.orange
        setupNavigationBar()
        
        getConfigParamaters()
        getOrderList()
        
        
        MBProgressHUD.showMessage("123456", to: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            MBProgressHUD.hideHUD()
        }
        
        let tmpView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tmpView.backgroundColor = UIColor.red
        tmpView.clipRoundedCorners(corners: [.topRight, .bottomRight], withRadii: CGSize(width: 10, height: 10))
        view.addSubview(tmpView)
        tmpView.width = 200
        
        let textImage: UIImageView = UIImageView(image: UIImage(named: "text_image")?.clipImageWith(cornerRadius: 20))
        textImage.frame = CGRect(x: 50, y: 200, width: 100, height: 100)
        view.addSubview(textImage)
    }
}

// MARK: -  网络请求
extension HomeViewController {
    func getConfigParamaters() {
        HttpNetwork.shared.requestWith(url: configParam, httpMethod: .post, params: [:], success: { (response) in
            guard let responseObject = response as? [String : Any] else { return }
            if let model = try? JSON2Model.JSONModel(HomeModel.self, withKeyValues: responseObject) {
                print("客服电话: \(model.kefu ?? "")")
            }
            
        }) { (error, errorMsg) in
            print("error = \(errorMsg)")
        }
    }
    
    func getOrderList() {
        HttpNetwork.shared.requestWith(url: assd, httpMethod: .post, params: [:], success: { (response) in
            guard let responseObject = response as? [String : Any] else { return }
            guard let listArray = responseObject["list"] as? [[String : Any]] else { return }
            
            if let modelList = try? JSON2Model.JSONModels(OrderModel.self, withKeyValuesArray: listArray) {
                for model in modelList {
                    print(model.name ?? "123")
                }
            }
            
        }) { (error, errorMsg) in
            print("error = \(errorMsg)")
        }
    }
}


// MARK: - UI界面
extension HomeViewController {
    
    /// 自定义导航栏
    fileprivate func setupNavigationBar() {
        // 城市位置按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cityButton)
        // 搜索框
        NotificationCenter.default.addObserver(self, selector: #selector(textFiledDidChange), name: UITextField.textDidChangeNotification, object: nil)
        navigationItem.titleView = searchBar
    }
    
    
}


// MARK: - 点击事件
extension HomeViewController {
    
    /// 点击了城市选择按钮
    @objc func cityButtonDidCilck(button: UIButton) {
        print(button.titleLabel?.text ?? "")
    }
    
}

// MARK: -  Text Field Delegate
extension HomeViewController: UITextFieldDelegate {
    /// 开始搜索
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("开始搜索")
    }
    
    /// 结束搜索
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("结束搜索")
    }
    
    /// 搜索框的值改变
    @objc func textFiledDidChange() {
        if let text = searchBar.searchField.text {
            if text.count > 0 {
                print(text)
            }
        }
    }
}

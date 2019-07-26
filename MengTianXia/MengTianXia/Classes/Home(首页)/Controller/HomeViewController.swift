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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tag = 10086
        view.backgroundColor = UIColor.orange
        setupNavigationBar()
        
        HttpNetwork.singleton.requestWith(url: assd, httpMethod: .post, params: [:], success: { (response) in
            if let responseObject = response as? [String : Any] {
                print("response = \(responseObject)")
                print("count = \(responseObject["count"] as? Int32 ?? -1)")
            }
            
            
        }) { (error, errorMsg) in
            print("error = \(errorMsg)")
        }
        
        MBProgressHUD.showMessage("123456", to: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
           MBProgressHUD.hideHUD()
        }
    }
}


// MARK: - UI界面
extension HomeViewController {
    
    /// 自定义导航栏
    fileprivate func setupNavigationBar() {
        // 城市位置按钮
        let cityButton = UIButton(type: .custom)
        cityButton.backgroundColor = UIColor.red
        cityButton.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
        cityButton.setTitle("临沂", for: .normal)
        cityButton.setTitleColor(BlackTextColor, for: .normal)
        cityButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cityButton.addTarget(self, action: #selector(cityButtonDidCilck(button:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cityButton)

        // 搜索框
        let searchBar = UISearchBar(frame: CGRect(x: 50, y: 30, width: 100, height: 44))
        searchBar.backgroundColor = UIColor.blue
        searchBar.placeholder = "搜索你需要的房源"
        let textField: UITextField = searchBar.value(forKey: "searchField") as! UITextField
        // 设置背景颜色及圆角
        textField.backgroundColor = BWColor(245, 245, 245)
        textField.layer.cornerRadius = 18
        textField.layer.masksToBounds = true
        // 文字大小及颜色
        textField.setValue(UIFont.systemFont(ofSize: 14), forKeyPath: "font")
        textField.setValue(BlackTextColor, forKeyPath: "textColor")
        // 占位文字大小及颜色
        textField.setValue(UIFont.systemFont(ofSize: 14), forKeyPath: "_placeholderLabel.font")
        textField.setValue(GrayTextColor, forKeyPath: "_placeholderLabel.textColor")
        
        navigationItem.titleView = searchBar
    }
}


// MARK: - 点击事件
extension HomeViewController {
    @objc func cityButtonDidCilck(button: UIButton) {
        BWLoading.hideHUD()
        print(button.titleLabel?.text ?? "")
    }
}

//
//  BWSearchBarView.swift
//  MengTianXia
//
//  Created by zl on 2019/7/26.
//  Copyright © 2019 LuMeng. All rights reserved.
//

import UIKit

class BWSearchBarView: UIView {
    var searchView: UIView
    var searchImage: UIImageView
    var searchField: UITextField
    
    override init(frame: CGRect) {
        searchView = UIView()
        searchView.backgroundColor = BWColor(245, 245, 245)
        searchView.layer.cornerRadius = 18
        searchView.layer.masksToBounds = true
        
        searchImage = UIImageView(image: UIImage(named: "search"))
        searchImage.contentMode = .scaleAspectFit
        
        searchField = UITextField()
        searchField.font = UIFont.systemFont(ofSize: 14)
        searchField.textColor = BlackTextColor
        searchField.placeholder = "搜索你需要的房源"
        searchField.clearButtonMode = .whileEditing
        
        searchView.addSubview(searchImage)
        searchView.addSubview(searchField)
        
        super.init(frame: frame)
        
        addSubview(searchView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let searchH: CGFloat = 36.0
        
        searchView.frame = CGRect(x: 0, y: (frame.height - 36) * 0.5, width: frame.width, height: searchH)
        searchImage.frame = CGRect(x: 10, y: 0, width: searchH * 0.5, height: searchH * 0.5)
        searchField.frame = CGRect(x: searchImage.frame.width + 16, y: 0, width: frame.width - searchImage.frame.width - 26, height: searchView.frame.height)
        searchImage.center.y = searchField.center.y
    }
    
}

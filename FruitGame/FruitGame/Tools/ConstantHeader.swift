//
//  PrefixHeader.swift
//  swift-APP框架搭建
//
//  Created by zl on 2019/5/30.
//  Copyright © 2019 ZHUNJIEE. All rights reserved.
//

import UIKit

/// 屏幕尺寸
let BWScreenW = UIScreen.main.bounds.width
let BWScreenH = UIScreen.main.bounds.height
// 状态栏的高度
let BWStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
// 导航栏高度
let BWNavHeight = 44
// TabBar的高度
let BWTabBarHeight = 49

/// 颜色相关
func BWColor(_ r: Int, _ g: Int, _ b: Int) -> UIColor {
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
}
func BWAlphaColor(_ r: Int, _ g: Int, _ b: Int, _ a: Float) -> UIColor {
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a / 1.0))
}

// 黑色字体
let BlackTextColor = BWColor(51, 51, 51)
// 灰色字体
let GrayTextColor = BWColor(153, 153, 153)



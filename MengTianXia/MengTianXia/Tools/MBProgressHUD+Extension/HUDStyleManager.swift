//
//  BWLoadingStyleManager.swift
//  MengTianXia
//
//  Created by zl on 2019/7/26.
//  Copyright © 2019 LuMeng. All rights reserved.
//

import UIKit

enum CustomHUDStyle: Int {
    case grayBackgroundStyle = 0    // 灰白背景
    case dimBackgroundStyle = 1     // 黑色背景(老版本样式)
}

class BWLoadingStyleManager: NSObject {
    static let sharedInstance = BWLoadingStyleManager()
    
    var hudStyle: CustomHUDStyle = .dimBackgroundStyle
    var hudShowTime: TimeInterval = 2.0
    
    
    func defaultStyle() {
        hudStyle = .dimBackgroundStyle
        hudShowTime = 2.0
    }
    
    //切记私有化初始化方法，防止外部通过init直接创建实例。
    private override init() {
        
    }
}

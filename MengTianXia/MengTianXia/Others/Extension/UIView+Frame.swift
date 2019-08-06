//
//  UIView+Extension.swift
//  MengTianXia
//
//  Created by zl on 2019/7/27.
//  Copyright © 2019 LuMeng. All rights reserved.
//

import UIKit

// MARK: - frame相关
extension UIView {
    var width: CGFloat {
        get { return frame.size.width }
        set { frame.size.width = newValue }
    }
    
    var height: CGFloat {
        get { return frame.size.height }
        set { frame.size.height = newValue }
    }
    
    var x: CGFloat {
        get { return frame.origin.x }
        set { frame.origin.x = newValue }
    }
    
    var y: CGFloat {
        get { return frame.origin.y }
        set { frame.origin.y = newValue}
    }
    
    var centerX: CGFloat {
        get { return center.x }
        set { center.x = newValue }
    }
    
    var centerY: CGFloat {
        get { return center.y }
        set { center.y = newValue }
    }
}

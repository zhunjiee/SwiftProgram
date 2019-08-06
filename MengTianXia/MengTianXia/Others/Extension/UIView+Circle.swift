//
//  UIView+CornerRadius.swift
//  MengTianXia
//
//  Created by zl on 2019/8/1.
//  Copyright © 2019 LuMeng. All rights reserved.
//

import UIKit

// MARK: - 剪裁圆角
extension UIView {
    
    /// 剪裁圆角(绝对布局, 只能剪裁,不能改变位置与大小)
    ///
    /// - Parameters:
    ///   - rectCorner: 需要剪裁的角      取多个值: [.topRight, .bottomRight]
    ///   - radii: 需要设置的圆角大小
    func clipRoundedCorners(corners: UIRectCorner, withRadii radii: CGSize) {
        let rounded = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: radii)
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        layer.mask = shape
    }
    
    /// 剪裁圆角(相对布局, 不仅能剪裁圆角,还能改变view的大小及位置)
    ///
    /// - Parameters:
    ///   - rectCorner: 需要剪裁的角  取值: .topLeft | .topRight | .bottomLeft | .bottomRight | .allCorners
    ///   - radii: 需要设置的圆角大小
    ///   - rect: 需要设置的圆角view的rect
    func clipRoundedCorners(corners: UIRectCorner, withRadii radii: CGSize, withRect rect: CGRect) {
        let rounded = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        layer.mask = shape
    }
}

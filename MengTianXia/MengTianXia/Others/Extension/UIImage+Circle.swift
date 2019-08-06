//
//  UIImage+Extension.swift
//  MengTianXia
//
//  Created by zl on 2019/7/27.
//  Copyright © 2019 LuMeng. All rights reserved.
//

import UIKit

// MARK: - 剪裁圆形图片
extension UIImage {
    
    /// 剪裁圆形图片
    ///
    /// - Returns: 剪裁完的圆形图片
    func circleImage() -> UIImage {
        // 开启基于位图的图形上下文
        UIGraphicsBeginImageContext(size)
        // 画圆
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(origin: CGPoint.zero, size: size)
        context?.addEllipse(in: rect)
        // 剪裁
        context?.clip()
        // 将图片画到圆上
        draw(in: rect)
        // 取出画好的图片
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        // 关闭位图上下文
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 图片剪裁圆角
    ///
    /// - Parameter cornerRadius: 圆角大小
    /// - Returns: 剪裁完的圆角图片
    func clipImageWith(cornerRadius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIBezierPath.init(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        return image
    }
}

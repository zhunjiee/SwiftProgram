//
//  CustomProgressView.swift
//  FruitGame
//
//  Created by zl on 2019/8/5.
//  Copyright © 2019 ZHUNJIEE. All rights reserved.
//

import UIKit

class CustomProgressView: UIView {
    var borderView: UIView?
    var progressView: UIView?
    var totalHeight: CGFloat = 0
    var progress: CGFloat = 0.0
    var seconds: Int = 10
    var timerInterval: Double = 0.01
    var timer: Timer = Timer()
    var isTransform: Bool = false
    
    override init(frame: CGRect) {
        totalHeight = frame.width - 2
        super.init(frame: frame)
        setupChlidView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupChlidView() {
        // 边框
        borderView = UIView()
        borderView?.backgroundColor = UIColor.white
        addSubview(borderView!)
        
        // 进度
        progressView = UIView()
        progressView?.backgroundColor = UIColor.orange
        addSubview(progressView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isTransform {
            borderView?.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.width)
            borderView?.layer.cornerRadius = frame.width * 0.5
            if frame.height - progress > 0 {
                progressView?.frame = CGRect(x: 1, y: 1, width: frame.height - progress - 2, height: frame.width - 2)
            } else {
                progressView?.frame = CGRect(x: 1, y: 1, width: 0, height: frame.width - 2)
            }
            
            progressView?.layer.cornerRadius = (frame.width - 2) * 0.5

        } else {
            borderView?.frame = bounds
            borderView?.layer.cornerRadius = frame.height * 0.5
            progressView?.frame = CGRect(x: 1, y: 1, width: frame.width - 2, height: frame.height - 2)
            progressView?.layer.cornerRadius = (frame.height - 2) * 0.5
        }
        

    }

    
    /// 暂停倒计时
    public func pauseProgress() {
        timer.invalidate()
    }
    
    /// 开启定时器,处理
    func startTimer() {
        timer = Timer(timeInterval: timerInterval, target: self, selector: #selector(dealProgress), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
            self.stopTimer()
        }
    }
    // 停止定时器
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func dealProgress() {
        // 通过时间计算缩放速度
        let velocity = totalHeight / CGFloat(seconds) * CGFloat(timerInterval)
        progress += velocity
        setNeedsLayout()
    }
}

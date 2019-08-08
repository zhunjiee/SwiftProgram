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
    var progress: CGFloat = 0.0
    var seconds: Int = 10
    var timerInterval: Double = 0.01
    var timer: Timer = Timer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        layer.cornerRadius = frame.width * 0.5
        layer.masksToBounds = true
        setupChlidView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupChlidView() {
        // 边框
        borderView = UIView()
        borderView?.backgroundColor = UIColor.white
        borderView?.clipsToBounds = true
        addSubview(borderView!)
        // 进度
        progressView = UIView()
        progressView?.backgroundColor = UIColor.orange
        borderView!.addSubview(progressView!)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderView?.frame = CGRect(x: 1, y: 1, width: frame.width - 2, height: frame.height - 2)
        borderView?.layer.cornerRadius = (frame.width - 2) * 0.5
        borderView?.layer.masksToBounds = true
        progressView?.frame = CGRect(x: 0, y: progress, width: borderView?.bounds.width ?? 0, height: borderView?.bounds.height ?? 0)
        progressView?.layer.cornerRadius = (frame.width - 2) * 0.5
        progressView?.layer.masksToBounds = true
    }
    
    /// 开启定时器
    func startTimer() {
        timer.invalidate()
        timer = Timer(timeInterval: timerInterval, target: self, selector: #selector(dealProgress), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        
        // 倒计时
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
            self.stopTimer()
        }
    }
    /// 停止定时器
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func dealProgress() {
        // 通过时间计算缩放速度
        let velocity = (frame.height - 2) / CGFloat(seconds) * CGFloat(timerInterval)
        progress += velocity
        setNeedsLayout()
    }
}

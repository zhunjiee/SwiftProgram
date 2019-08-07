//
//  ViewController.swift
//  FruitGame
//
//  Created by zl on 2019/8/2.
//  Copyright © 2019 ZHUNJIEE. All rights reserved.
//

import UIKit

// 常量定义
let fruitWH: CGFloat = 60.0

class ViewController: UIViewController {
    @IBOutlet weak var bgView: BackgrounView!   // 背景视图
    @IBOutlet weak var alertParentView: UIView!     // 添加点击得分的视图
    @IBOutlet weak var gameRuleBtn: UIButton!   // 游戏规则
    @IBOutlet weak var silenceBtn: UIButton!    // 静音按钮
    @IBOutlet weak var centerImgView: UIImageView!  // 开始前的水果占位图
    @IBOutlet weak var beginBtn: UIButton!  // 开始游戏按钮
    @IBOutlet weak var speakBtn: UIButton!  // 讲话按钮
    @IBOutlet weak var silenceBtnTopCons: NSLayoutConstraint!   // 静音按钮距离顶部约束
    var gameTimer: Timer = Timer()  // 游戏时间定时器
    var createFruitTimer: Timer = Timer()  // 重复生成水果的定时器
    var fruitTime: Int = 0  // 产生水果的时间
    var animationTime: Double = 6.0 // 水果下落的时间
    var fruitModelArray = [FruitModel?]() // 存放水果模型的数组
    var showFruitArray = [FruitModel?]()   // 屏幕显示的水果数组
    var createIndex: Int = 0  // 生成水果的索引
    var totalScore: Int = 0 // 总的分数
    
    // MARK: -  懒加载
    // 游戏规则视图
    lazy var gameRuleView: GameRuleView = {
        let ruleView = Bundle.main.loadNibNamed("GameRuleView", owner: nil, options: nil)?.first as! GameRuleView
        ruleView.frame = view.bounds
        return ruleView
    }()
    // 游戏结束后弹出的视图
    lazy var gameOverView: GameOverView = {
        let overView = Bundle.main.loadNibNamed("GameOverView", owner: nil, options: nil)?.first as! GameOverView
        overView.closeBtn.addTarget(self, action: #selector(closeBtnDidClick), for: .touchUpInside)
        overView.playAgainBtn.addTarget(self, action: #selector(playAgainBtnDidClick), for: .touchUpInside)
        overView.frame = view.bounds
        return overView
    }()
     // 倒计时进度条
    lazy var progressView: CustomProgressView = {
        let progressView = CustomProgressView(frame: CGRect(x: 0.0, y: 0.0, width: 290.0, height: 12.0))
        progressView.center = CGPoint(x: 15, y: BWScreenH * 0.5)
        progressView.transform = CGAffineTransform.init(rotationAngle: -.pi/2)   // 旋转90度
        progressView.isTransform = true
        return progressView
    }()
    
    
    // 临时数据
    let tempArray: Array = [
        [
            "id" : 1,
            "pic" : "pingguo",
            "name" : "苹果",
            "score" : 12,
        ],
        [
            "id" : 2,
            "pic" : "caomei",
            "name" : "草莓",
            "score" : 15,
        ],
        [
            "id" : 3,
            "pic" : "chengzi",
            "name" : "橙子",
            "score" : 14,
        ],
        [
            "id" : 4,
            "pic" : "ningmeng",
            "name" : "柠檬",
            "score" : 5,
        ],
        [
            "id" : 5,
            "pic" : "sangshen",
            "name" : "桑葚",
            "score" : 6,
        ],
        [
            "id" : 6,
            "pic" : "shumei",
            "name" : "树莓",
            "score" : 7,
        ],
        [
            "id" : 7,
            "pic" : "pingguo",
            "name" : "苹果",
            "score" : 12,
        ],
        [
            "id" : 8,
            "pic" : "caomei",
            "name" : "草莓",
            "score" : 15,
        ],
        [
            "id" : 9,
            "pic" : "chengzi",
            "name" : "橙子",
            "score" : 14,
        ],
        [
            "id" : 10,
            "pic" : "ningmeng",
            "name" : "柠檬",
            "score" : 5,
        ]
    ]
    
    // MARK: -  初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        bgViewAddTapGesture()
        
        if let modelArray = try? JSON2Model.JSONModels(FruitModel.self, withKeyValuesArray: tempArray) {
            fruitModelArray = modelArray
            // 游戏时间 = 水果数量+ 最后一组下落动画的时间
            fruitTime = fruitModelArray.count;
            print("一共有\(fruitModelArray.count)个水果")
        }
    }

    
    /// 添加点击事件
    func bgViewAddTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickFruit(tapGesture:)))
        alertParentView.addGestureRecognizer(tap)
    }
    
    /// 创建水果下落动画
    @objc func showFruitRain() {
        showFruitArray.append(fruitModelArray[createIndex])
        //创建画布
        let moveLayer = CALayer()
        moveLayer.backgroundColor = UIColor.green.cgColor
        moveLayer.bounds = CGRect(x: 0, y: 0, width: fruitWH, height: fruitWH)
        moveLayer.anchorPoint = CGPoint(x: 0, y: 0)
        moveLayer.position = CGPoint(x: 0, y: -fruitWH)
        let model = showFruitArray.last
        moveLayer.contents = UIImage(named: model??.pic ?? "pingguo")?.cgImage
        bgView.layer.addSublayer(moveLayer)
        
        //此处keyPath为CALayer的属性
        let  moveAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        //动画路线，一个数组里有多个轨迹点
        var randomX = CGFloat(arc4random_uniform(UInt32(BWScreenW)))
        // 不让水果贴边或显示不全
        randomX =  randomX < 20 ? 20 : randomX
        randomX = randomX > BWScreenW - fruitWH ? BWScreenW - fruitWH - 20 : randomX
        let valueA = NSValue(cgPoint: CGPoint(x: randomX, y: -moveLayer.frame.height))
        let valueB = NSValue(cgPoint: CGPoint(x: randomX, y: BWScreenH))
        moveAnimation.values = [valueA, valueB]
        //动画间隔
        moveAnimation.duration = animationTime
        //重复次数
        moveAnimation.repeatCount = 1
        //动画的速度
        moveAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        moveAnimation.delegate = self
        moveLayer.add(moveAnimation, forKey: "move")
        createIndex += 1
    }
    
    // MARK: -  私有方法
    
    /// 开始动画
    public func startAnimation() {
        print("开始水果下落")
        // 防止timer重复添加
        self.createFruitTimer.invalidate()
        self.createFruitTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.showFruitRain), userInfo: nil, repeats: true)
    }
    
    /// 结束动画
    public func stopAnimation() {
        createIndex = 0
        showFruitArray.removeAll()
        print("停止水果下落")
        //删除当前红包layers
        if let sublayers = bgView.layer.sublayers {
            for item in sublayers {
                item.removeAllAnimations()
                item.removeFromSuperlayer()
            }
        }
        dismiss(animated: true)
    }
    
    /// 开始游戏
    func beginGame() {
        // 总分清零
        totalScore = 0
        // 添加倒计时控件
        view.addSubview(progressView)
        progressView.progress = 0.0
        progressView.seconds = fruitTime + Int(animationTime)
        progressView.startTimer()
        // 开启水果下落动画
        startAnimation()
        // 停止生成水果
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(fruitTime)) {
            self.createFruitTimer.invalidate()
        }
        // 结束游戏
        gameTimer = Timer.scheduledTimer(withTimeInterval: Double(fruitTime) + animationTime, repeats: false, block: { (timer) in
            self.stopAnimation()
            self.gameOverView.scoreLabel.text = String(format: "%d", self.totalScore)
            // 弹出结束界面
            self.view.addSubview(self.gameOverView)
            timer.invalidate()
        })
    }
    
    // MARK: -  点击事件
    
    /// 点击了开始游戏按钮
    @IBAction func beginGameBtnDidClick(_ sender: UIButton) {
        // 设置控件的显示状态
        sender.isHidden = true
        centerImgView.isHidden = true
        speakBtn.isHidden = false
        gameRuleBtn.isHidden = true
        progressView.isHidden = false
        silenceBtnTopCons.constant = 15
        // 开始游戏
        beginGame()
    }
    
    /// 讲话完成
    @IBAction func speakBtnDidClick(_ sender: UIButton) {
        let speakIndex = arc4random_uniform(10) + 1
        completeSpeakWith(fruitIndex: Int(speakIndex))
    }
    
    /// 返回
    @IBAction func backBtnDidClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    /// 游戏规则
    @IBAction func gameRuleBtnDidClick(_ sender: UIButton) {
        view.addSubview(gameRuleView)
    }
    /// 静音
    @IBAction func silenceBtnDidClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}


// MARK: - 事件监听
extension ViewController {
    
    /// 点击了水果
    ///
    /// - Parameter tapgesture: 点击手势
    @objc private func clickFruit(tapGesture: UITapGestureRecognizer) {
        let tempPoint = tapGesture.location(in: alertParentView)
        // 转换坐标到bgview上
        let touchPoint = bgView.convert(tempPoint, from: alertParentView)
        // 获取所有的子layer
        guard let sublayers = self.bgView.layer.sublayers else { return }
//        print("sublayers.count = \(sublayers.count)")
        // 遍历子layer,匹配点击位置是否在子layer上
        for (index, layer) in sublayers.enumerated() {
            if (layer.presentation()?.hitTest(touchPoint) != nil && layer.value(forKey: "clicked") as? String != "YES") {
                // 设置被点击的标志,避免重复点击
                layer.setValue("YES", forKey: "clicked")
                
                let model = showFruitArray[index]
                // 计算总得分
                totalScore += model?.score ?? 0
                // 创建并显示点击得分
                let alertView  = UIView()
                alertView.frame = CGRect(x: touchPoint.x - 30, y: touchPoint.y, width: 100, height: 40)
                alertParentView.addSubview(alertView)
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 40)
                label.textAlignment = .center
                label.text = String(format: "+%d", model?.score ?? 0)
                label.textColor = BWColor(250, 198, 1)
                label.frame = CGRect(x: 0, y: 0, width: alertView.frame.width, height: alertView.frame.height)
                alertView.addSubview(label)
                
                // 添加得分动画
                UIView.animate(withDuration: 0.25, animations: {
                    alertView.alpha = 0
                    alertView.frame = CGRect(x: touchPoint.x - 30, y: touchPoint.y - 30, width: 100, height: 40)
                    // 设置被点击后的图片
                    layer.contents = UIImage(named: "sangshen")?.cgImage
                }) { (finished) in
                    alertView.removeFromSuperview()
                    layer.removeFromSuperlayer()
                    if self.showFruitArray[index] != nil {
                        self.showFruitArray.remove(at: index)
                    }
                    // 判断是否点击的是最后一个水果(屏幕上没有其他水果了),提前结束游戏
                    if self.showFruitArray.count == 0 {
                        // 最后一个水果提前结束动画
                        self.stopAnimation()
                        self.gameTimer.invalidate()
                        self.progressView.pauseProgress()
                         self.gameOverView.scoreLabel.text = String(format: "%d", self.totalScore)
                        self.view.addSubview(self.gameOverView)
                    }
                }
                
                break
            }
        }
    }
    
    /// 再来一次
    @objc func playAgainBtnDidClick() {
        progressView.removeFromSuperview()
        gameOverView.removeFromSuperview()
        
        // 开始游戏
        beginGame()
    }
    
    /// 游戏结束后关闭
    @objc func closeBtnDidClick() {
        beginBtn.isHidden = false
        speakBtn.isHidden = true
        centerImgView.isHidden = false
        gameRuleBtn.isHidden = false
        progressView.isHidden = true
        silenceBtnTopCons.constant = 60
        gameOverView.removeFromSuperview()
        progressView.removeFromSuperview()

    }
}


// MARK: -  讲话完成的方法
extension ViewController {
    fileprivate func completeSpeakWith(fruitIndex: Int) {
        guard let sublayers = self.bgView.layer.sublayers else { return }
        // 遍历子layer,匹配是否有符合条件的子layer
        for (index, layer) in sublayers.enumerated() {
            let model = showFruitArray[index]
            print("fruitIndex = \(fruitIndex), model.ID = \(model?.ID ?? -1)")
            if (model?.ID == fruitIndex && layer.value(forKey: "clicked") as? String != "YES") {
                print("layer.frame = \(layer.frame)")
                // 设置被点击的标志,避免重复点击
                layer.setValue("YES", forKey: "clicked")
                // 计算总得分
                totalScore += model?.score ?? 0
                // 创建并显示点击得分
                let alertView  = UIView()
                // 获取动画中的位置
                let animateX = (layer.presentation()?.frame.origin.x ?? 0) - fruitWH*0.5
                let animateY = layer.presentation()?.frame.origin.y ?? 0
                alertView.frame = CGRect(x: animateX, y: animateY, width: 100, height: 40)
                alertParentView.addSubview(alertView)
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 40)
                label.textAlignment = .center
                label.text = String(format: "+%d", model?.score ?? 0)
                label.textColor = BWColor(250, 198, 1)
                label.frame = CGRect(x: 0, y: 0, width: alertView.frame.width, height: alertView.frame.height)
                alertView.addSubview(label)
                
                // 添加得分动画
                UIView.animate(withDuration: 0.5, animations: {
                    alertView.alpha = 0
                    alertView.frame = CGRect(x: animateX, y: animateY - 30, width: 100, height: 40)
                    // 设置被点击后的图片
                    layer.contents = UIImage(named: "sangshen")?.cgImage
                    
                }) { (finished) in
                    layer.removeFromSuperlayer()
                    alertView.removeFromSuperview()
                    if self.showFruitArray.count >= index + 1 {
                        self.showFruitArray.remove(at: index)
                    }
                    // 判断是否点击的是最后一个水果(屏幕上没有其他水果了),提前结束游戏
                    if self.showFruitArray.count == 0 {
                        // 最后一个水果提前结束动画
                        self.stopAnimation()
                        self.gameTimer.invalidate()
                        self.progressView.pauseProgress()
                        self.gameOverView.scoreLabel.text = String(format: "%d", self.totalScore)
                        self.view.addSubview(self.gameOverView)
                    }
                }
                
                break
            }
        }
    }
}


// MARK: - GameRuleDelegate
extension ViewController: GameRuleDelegate {
    func gameRuleCloseBtnDidClick() {
        
    }
}


// MARK: -  CAAnimationDelegate
extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // 落下去的水果清除掉,有利于计算屏幕上剩余的水果数量
        if flag {
            guard let first = bgView.layer.sublayers?.first else { return }
            first.removeFromSuperlayer()
            if showFruitArray.count != 0 {
                showFruitArray.removeFirst()
            }
        }
        print("屏幕上现在一共有\(showFruitArray.count)个水果")
    }
}

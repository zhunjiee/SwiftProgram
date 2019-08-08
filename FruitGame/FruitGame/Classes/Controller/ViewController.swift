//
//  ViewController.swift
//  FruitGame
//
//  Created by zl on 2019/8/2.
//  Copyright © 2019 ZHUNJIEE. All rights reserved.
//

import UIKit

// 常量定义
let fruitWH: CGFloat = BWScreenW * 0.2
// 游戏模式
enum GameModeType {
    case tapMode
    case voiceMode
}

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
    var animationTime: Double = 3.0 // 水果下落的时间
    var fruitModelArray = [FruitModel?]() // 存放水果模型的数组
    var showFruitArray = [FruitModel?]()   // 屏幕显示的水果数组
    var createIndex: Int = 0  // 生成水果的索引
    var totalScore: Int = 0 // 总的分数
    var gameMode: GameModeType = .voiceMode   // 游戏模式
    
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
        let progressView = CustomProgressView(frame: CGRect(x: 0, y: 0, width: 12, height: 290))
        progressView.center = CGPoint(x: 15, y: BWScreenH * 0.5)
        return progressView
    }()
    // 温馨提示视图
    lazy var gameAlertView: GameAlertView = {
        let alertView = Bundle.main.loadNibNamed("GameAlertView", owner: nil, options: nil)?.first as! GameAlertView
        alertView.frame = view.bounds
        return alertView
    }()
    
    
    // 临时数据
    let tempArray: Array = [
        [
            "id" : 1,
            "pic" : "pingguo",
            "name" : "苹果",
            "score" : 1,
        ],
        [
            "id" : 2,
            "pic" : "caomei",
            "name" : "草莓",
            "score" : 2,
        ],
        [
            "id" : 5,
            "pic" : "sangshen",
            "name" : "桑葚",
            "score" : 5,
        ],
        [
            "id" : 3,
            "pic" : "chengzi",
            "name" : "橙子",
            "score" : 3,
        ],
        [
            "id" : 4,
            "pic" : "ningmeng",
            "name" : "柠檬",
            "score" : 4,
        ],
        [
            "id" : 6,
            "pic" : "shumei",
            "name" : "树莓",
            "score" : 6,
        ],
        [
            "id" : 1,
            "pic" : "pingguo",
            "name" : "苹果",
            "score" : 1,
        ],
        [
            "id" : 3,
            "pic" : "chengzi",
            "name" : "橙子",
            "score" : 3,
        ],
        [
            "id" : 5,
            "pic" : "sangshen",
            "name" : "桑葚",
            "score" : 5,
        ],
        [
            "id" : 6,
            "pic" : "shumei",
            "name" : "树莓",
            "score" : 6,
        ],
        [
            "id" : 4,
            "pic" : "ningmeng",
            "name" : "柠檬",
            "score" : 4,
        ],
        [
            "id" : 1,
            "pic" : "pingguo",
            "name" : "苹果",
            "score" : 1,
        ],
        [
            "id" : 1,
            "pic" : "pingguo",
            "name" : "苹果",
            "score" : 1,
        ],
        [
            "id" : 2,
            "pic" : "caomei",
            "name" : "草莓",
            "score" : 2,
        ],
        [
            "id" : 3,
            "pic" : "chengzi",
            "name" : "橙子",
            "score" : 3,
        ],
        [
            "id" : 1,
            "pic" : "pingguo",
            "name" : "苹果",
            "score" : 1,
        ],
        [
            "id" : 4,
            "pic" : "ningmeng",
            "name" : "柠檬",
            "score" : 4,
        ],
        [
            "id" : 5,
            "pic" : "sangshen",
            "name" : "桑葚",
            "score" : 5,
        ],
        [
            "id" : 6,
            "pic" : "shumei",
            "name" : "树莓",
            "score" : 6,
        ],
    ]
    
    // MARK: -  初始化
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置游戏模式
//        gameMode = .tapMode
        if gameMode == .tapMode {
            bgViewAddTapGesture()
        }
        speakButtonAddLongPressGesture()
        
        // 字典转模型
        if let modelArray = try? JSON2Model.JSONModels(FruitModel.self, withKeyValuesArray: tempArray) {
            fruitModelArray = modelArray
            fruitTime = fruitModelArray.count;
        }
    }
    
    /// 创建水果下落动画
    @objc func showFruitRain() {
        // 超过index不再生成新的水果
        if createIndex > fruitModelArray.count - 1 { return }
        
        let model = fruitModelArray[createIndex]
        showFruitArray.append(model)
        //创建画布
        let moveLayer = CALayer()
        moveLayer.setValue("show", forKey: "showStatus")    // layer的显示状态
        moveLayer.setValue(createIndex, forKey: "layerId")    // 与animation绑定相同的id,用于在animationDidStop中确认是哪个layer
        moveLayer.bounds = CGRect(x: 0, y: 0, width: fruitWH, height: fruitWH)
        moveLayer.anchorPoint = CGPoint(x: 0, y: 0)
        moveLayer.position = CGPoint(x: 0, y: -fruitWH)
        moveLayer.contents = UIImage(named: model?.pic ?? "pingguo")?.cgImage
        bgView.layer.addSublayer(moveLayer)
        
        //此处keyPath为CALayer的属性
        let moveAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
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
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.setValue(createIndex, forKey: "animateId")    // 与layer绑定相同的id,用于在animationDidStop中确认是哪个layer
        moveAnimation.delegate = self
        moveLayer.add(moveAnimation, forKey: "move")
        
        createIndex += 1
    }
    
    
    // MARK: -  私有方法

    /// 开始动画
    public func startAnimation() {
        print("开始水果下落")
        // 防止timer重复添加
        createFruitTimer.invalidate()
        createFruitTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(showFruitRain), userInfo: nil, repeats: true)
    }
    
    /// 结束动画
    public func stopAnimation() {
        showFruitArray.removeAll()
        print("停止水果下落")
        //删除当前水果layers
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
        // 相关数据清零
        createIndex = 0
        totalScore = 0
        // 添加倒计时控件
        view.addSubview(progressView)
        progressView.progress = 0.0
        progressView.seconds = fruitTime + Int(animationTime)
        progressView.startTimer()
        // 开启水果下落动画
        startAnimation()
        
        // 定时结束游戏
        gameTimer.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: Double(fruitTime) + animationTime, target: self, selector: #selector(endGameWithTimer(_:)), userInfo: nil, repeats: false)
    }
    
    // 正常结束游戏
    @objc func endGameWithTimer(_ timer: Timer) {
        createFruitTimer.invalidate()
        timer.invalidate()
        stopAnimation()
        progressView.stopTimer()
        progressView.removeFromSuperview()
        gameOverView.scoreLabel.text = String(format: "%d", totalScore)
        view.addSubview(gameOverView)
    }
    
    // 提前结束游戏
    func earlyEndGame() {
        // 若页面没有水果了,提前结束动画
        guard let sublayers = bgView.layer.sublayers else { return }
        var allHidden:Int = 0
        for layer in sublayers {
            let showStatus = layer.value(forKey: "showStatus") as? String
            if showStatus == "hidden" {
                allHidden += 1
            }
        }
        if allHidden == fruitModelArray.count {
            gameTimer.invalidate()
            stopAnimation()
            progressView.stopTimer()
            progressView.removeFromSuperview()
            gameOverView.scoreLabel.text = String(format: "%d", totalScore)
            view.addSubview(gameOverView)
        }
    }
    
    
    // MARK: -  点击事件
    /// 添加点击事件
    func bgViewAddTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickFruit(tapGesture:)))
        alertParentView.addGestureRecognizer(tap)
    }
    
    /// 讲话按钮添加长按手势
    func speakButtonAddLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(clickSpeakButton(longPress:)))
        longPress.minimumPressDuration = 0.5
        speakBtn.addGestureRecognizer(longPress)
    }
    
    /// 点击了开始游戏按钮
    @IBAction func beginGameBtnDidClick(_ sender: UIButton) {
        // 设置控件的显示状态
        sender.isHidden = true
        centerImgView.isHidden = true
        if gameMode == .voiceMode {
            speakBtn.isHidden = false
        }
        gameRuleBtn.isHidden = true
        silenceBtnTopCons.constant = 15
        // 开始游戏
        beginGame()
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
    /// 点击水果
    @objc func clickFruit(tapGesture: UITapGestureRecognizer) {
        let tempPoint = tapGesture.location(in: alertParentView)
        // 转换坐标到bgview上
        let touchPoint = bgView.convert(tempPoint, from: alertParentView)
        // 获取所有的子layer
        guard let sublayers = self.bgView.layer.sublayers else { return }
        // 遍历子layer,匹配点击位置是否在子layer上
        for (index, layer) in sublayers.enumerated() {
            if (layer.presentation()?.hitTest(touchPoint) != nil && layer.value(forKey: "clicked") as? String != "YES") {
                // 设置被点击的标志,避免重复点击
                layer.setValue("YES", forKey: "clicked")
                let model = showFruitArray[index]
                // 计算总得分
                totalScore += model?.score ?? 0
                // 创建并显示点击得分
                createScoreViewWithLayer(layer, score: model?.score ?? 0)
                break
            }
        }
    }
    
    /// 长按讲话
    @objc func clickSpeakButton(longPress: UILongPressGestureRecognizer) {
        switch longPress.state {
        case .began:
            // 开始输入
            print("开始录音")
        case .ended:
            // 结束录入,结果解析
            let speakIndex = arc4random_uniform(UInt32(6)) + 1
            print("speakIndex\(speakIndex)")
            completeSpeakWithFruitIndex(Int(speakIndex))
        default:
            break
        }
    }
    
    /// 点击再来一次按钮
    @objc func playAgainBtnDidClick() {
        gameOverView.removeFromSuperview()
        // 开始游戏
        beginGame()
    }
    
    /// 游戏结束后点击关闭按钮
    @objc func closeBtnDidClick() {
        beginBtn.isHidden = false
        speakBtn.isHidden = true
        centerImgView.isHidden = false
        gameRuleBtn.isHidden = false
        silenceBtnTopCons.constant = 60
        gameOverView.removeFromSuperview()
        progressView.removeFromSuperview()
    }
}


// MARK: -  讲话完成的方法
extension ViewController {
    // 讲话完成后匹配元素
    fileprivate func completeSpeakWithFruitIndex(_ fruitIndex: Int) {
        guard let sublayers = self.bgView.layer.sublayers else { return }
        // 遍历子layer,匹配是否有符合条件的子layer
        for (index, layer) in sublayers.enumerated() {
            if layer.value(forKey: "showStatus") as? String == "show" {
                let model = showFruitArray[index]
                if (model?.ID == fruitIndex && layer.value(forKey: "clicked") as? String != "YES") {
                    // 设置被点击的标志,避免重复点击
                    layer.setValue("YES", forKey: "clicked")
                    // 计算总得分
                    totalScore += model?.score ?? 0
                    // 创建并显示得分视图
                    createScoreViewWithLayer(layer, score: model?.score ?? 0)
                    break
                }
            }
        }
    }
    
    /// 创建得分视图
    ///
    /// - Parameters:
    ///   - layer: 通过layer的frame确认视图的位置
    ///   - score: 得分
    fileprivate func createScoreViewWithLayer(_ layer: CALayer, score: Int) {
        // 获取layer在动画过程中的位置
        let animateX = (layer.presentation()?.frame.origin.x ?? 0) - fruitWH*0.5
        let animateY = layer.presentation()?.frame.origin.y ?? 0
        let alertView  = UIView()
        alertView.frame = CGRect(x: animateX, y: animateY, width: 100, height: 40)
        alertParentView.addSubview(alertView)
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .center
        label.text = String(format: "+%d", score)
        label.textColor = BWColor(250, 198, 1)
        label.frame = CGRect(x: 0, y: 0, width: alertView.frame.width, height: alertView.frame.height)
        alertView.addSubview(label)
        // 添加得分动画
        UIView.animate(withDuration: 0.5, animations: {
            print("添加得分\(score)")
            alertView.alpha = 0.5
            alertView.frame = CGRect(x: animateX, y: animateY - 20, width: 100, height: 40)
            // 设置被点击后的图片
//            layer.contents = UIImage(named: "sangshen")?.cgImage
        }) { (finished) in
            layer.removeAnimation(forKey: "move")
            layer.setValue("hidden", forKey: "showStatus")
            layer.backgroundColor = UIColor.purple.cgColor
            alertView.removeFromSuperview()
            // 若页面没有水果了,提前结束动画
            self.earlyEndGame()
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
        // 设置落下去的水果layer的显示状态
        if flag {
            // 通过anim找到layer
            let animateId = anim.value(forKeyPath: "animateId") as? Int
            guard let sublayers = bgView.layer.sublayers else { return }
            for layer in sublayers {
                let layerId = layer.value(forKey: "layerId") as? Int
                if layerId == animateId {
                    layer.backgroundColor = UIColor.brown.cgColor
                    layer.setValue("hidden", forKey: "showStatus")
                    break
                }
            }
            // 若页面没有水果了,提前结束动画
            self.earlyEndGame()
        }
    }
}

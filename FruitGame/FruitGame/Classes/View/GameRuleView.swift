//
//  GameRuleView.swift
//  FruitGame
//
//  Created by zl on 2019/8/5.
//  Copyright © 2019 ZHUNJIEE. All rights reserved.
//

import UIKit

protocol GameRuleDelegate: NSObjectProtocol {
    func gameRuleCloseBtnDidClick()
}

class GameRuleView: UIView {
    weak var delegate: GameRuleDelegate?
    @IBOutlet weak var closeBtn: UIButton!
    
    /// 关闭游戏说明界面
    @IBAction func closeBtnDidClick(_ sender: UIButton) {
        self.removeFromSuperview()
        delegate?.gameRuleCloseBtnDidClick()
    }
}

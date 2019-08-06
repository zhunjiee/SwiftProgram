//
//  BackgrounView.swift
//  FruitGame
//
//  Created by zl on 2019/8/5.
//  Copyright © 2019 ZHUNJIEE. All rights reserved.
//

import UIKit

class BackgrounView: UIView {

    override func draw(_ rect: CGRect) {
        let image = UIImage(named: "bg")
        image?.draw(in: rect)
    }
}

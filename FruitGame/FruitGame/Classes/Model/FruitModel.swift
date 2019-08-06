//
//  FruitModel.swift
//  FruitGame
//
//  Created by zl on 2019/8/6.
//  Copyright © 2019 ZHUNJIEE. All rights reserved.
//

import UIKit

class FruitModel: Codable {
    var ID: Int?    // 一定注意类型与后台一致问题,否则可能出现无法解析的问题
    var pic: String?
    var name: String?
    var score: Int?
    
    
    // key不一致的问题
    private enum CodingKeys: String, CodingKey {
        case ID = "id"
        case pic
        case name
        case score
    }
}

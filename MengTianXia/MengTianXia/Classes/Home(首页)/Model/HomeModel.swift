//
//  HomeModel.swift
//  MengTianXia
//
//  Created by zl on 2019/8/1.
//  Copyright © 2019 LuMeng. All rights reserved.
//

import Foundation

class HomeModel: Codable {
    var kefu: String?
    var add_adv: String?
    var baojing: String?
    var gongsi: String?
}

class OrderModel: Codable {
    var ID: Int?    // 一定注意类型与后台一致问题,否则可能出现无法解析的问题
    var createtime: String?
    var name: String?
    var description: String?
    var url: String?
    var title: String?
    var small_title: String?
    
    // key不一致的问题
    private enum CodingKeys: String, CodingKey {
        case ID = "id"
        case createtime
        case name
        case description
        case url
        case title
        case small_title
        
        // 不写的可以就不会解析
    }
}

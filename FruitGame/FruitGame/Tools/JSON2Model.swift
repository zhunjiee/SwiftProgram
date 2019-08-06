//
//  BWJsonToModel.swift
//  MengTianXia
//
//  Created by zl on 2019/8/1.
//  Copyright © 2019 LuMeng. All rights reserved.
//

import Foundation

class JSON2Model: NSObject {
    
    /// 字典转模型
    class func JSONModel<T>(_ type: T.Type, withKeyValues data:[String:Any]) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        let model = try JSONDecoder().decode(type, from: jsonData)
        return model
    }
    
    /// 字典数组 转 模型数组
    class func JSONModels<T>(_ type: T.Type, withKeyValuesArray datas: [[String:Any]]) throws -> [T]  where T: Decodable {
        var temp: [T] = []
        for data in datas {
            let model = try self.JSONModel(type, withKeyValues: data)
            temp.append(model)
        }
        return temp
    }
}

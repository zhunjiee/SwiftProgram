//
//  BWUserDefaults.swift
//  MengTianXia
//
//  Created by zl on 2019/8/1.
//  Copyright © 2019 LuMeng. All rights reserved.
//

import UIKit

// 用户登录状态
let CustomerState = "CUSTOMERSTATE"
let UserToken = "USERTOKEN"
let UserId = "USERID"
let PhoneNumber = "PHONENUMBER"
let UserName = "USERNAME"


class BWUserDefaults: NSObject {
    // 单例
    static let shareInstance = BWUserDefaults()
    
    /// 获取用户登录状态
    public func getCustomerState() -> Bool {
        let state = UserDefaults.standard.object(forKey: CustomerState) as? String
        if state == nil {
            UserDefaults.standard.set("0", forKey: CustomerState)
            UserDefaults.standard.synchronize()
            return false
        }
        if state == "1" {
            return true
        }
        return false
    }

    /// 保存用户登录状态
    public func setCustomerState(state: Bool) {
        if state {
            // 登录
            UserDefaults.standard.set("1", forKey: CustomerState)
        } else {
            // 退出登录
            UserDefaults.standard.set("0", forKey: CustomerState)
            // 清除数据
            clearCustomerData()
        }
    }
    
    
    /// uid
    public func getUserId() -> String? {
        let userId = UserDefaults.standard.object(forKey: UserId) as? String
        return userId
    }
    public func setUserId(userId: String) {
        UserDefaults.standard.set(userId, forKey: UserId)
        UserDefaults.standard.synchronize()
    }
    
    /// token
    public func getUserToken() -> String? {
        let token = UserDefaults.standard.object(forKey: UserToken) as? String
        return token
    }
    public func setUserToken(token: String) {
        UserDefaults.standard.set(token, forKey: UserToken)
        UserDefaults.standard.synchronize()
    }
    
    /// 手机号
    public func getPhoneNumber() -> String? {
        let phone = UserDefaults.standard.object(forKey: PhoneNumber) as? String
        return phone
    }
    public func setPhoneNumber(number: String) {
        UserDefaults.standard.set(number, forKey: PhoneNumber)
        UserDefaults.standard.synchronize()
    }
    
    /// 用户名
    public func getUserName() -> String? {
        let name = UserDefaults.standard.object(forKey: UserName) as? String
        return name
    }
    public func setUserName(name: String) {
        UserDefaults.standard.set(name, forKey: UserName)
        UserDefaults.standard.synchronize()
    }
}


// MARK: - 私有方法
extension BWUserDefaults {
    /// 清除用户数据
    func clearCustomerData() {
        UserDefaults.standard.set("0", forKey: CustomerState)
        UserDefaults.standard.set("", forKey: UserToken)
        UserDefaults.standard.set("", forKey: UserId)
        UserDefaults.standard.set("", forKey: PhoneNumber)
        UserDefaults.standard.set("", forKey: UserName)
    }
}

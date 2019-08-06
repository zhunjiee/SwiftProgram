//
//  HttpNetwork.swift
//  MengTianXia
//
//  Created by zl on 2019/7/25.
//  Copyright © 2019 LuMeng. All rights reserved.
//

import UIKit
import Alamofire

//自定义错误类型，区别网络获取
let customErrorCode = "CUSTOM_ERROR_CODE"

typealias ReqRsponseSuccess = (_ response: Any) -> Void
typealias ReqResponseFail = (_ errorCode: String, _ errorMsg: String) -> Void
typealias NetworkStatus = (_ HTNetworkStatus: Int32) -> Void

@objc enum HTNetworkStatus: Int32 {
    case  HttpUnknow       = -1  //未知
    case  HttpNoReachable  = 0  // 无网络
    case  HttpWwan         = 1   //2g ， 3g 4g
    case  HttpWifi         = 2  // wifi
}

struct HTTPAPI {
    // 设置公共域名或者IP
    static let  hostName = "http://youyou.qdunzi.com"
}

enum methodType {
    case RequestMethodGet
    case RequestMethodPost
}


class HttpNetwork: NSObject {
    //1.创建类的实例变量
    //2.let是线程安全的
    // 对于单例实例来说，需要创建一个唯一对外输出实例的方法
    // 静态变量用static来处理
    static let shared  = HttpNetwork()
    
    ///当前网络状态
    var htNetworkStatus: HTNetworkStatus = HTNetworkStatus.HttpWifi
    
    public func getRequestWith(url: String,
                               params:[String: Any]?,
                               success:@escaping ReqRsponseSuccess,
                               error:@escaping ReqResponseFail) {

        let  httpUrl = HTTPAPI.hostName + url
        // 设置请求头
        var headers = [String : String]()
        guard let token = BWUserDefaults.shareInstance.getUserToken() else {
            return
        }
        headers["token"] = token
        
        Alamofire.request(httpUrl, method: .get, parameters: params, encoding:URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let value = response.result.value as? [String: Any] else { break }
                let responseCode = String(value["code"] as? Int32 ?? -998)
                if responseCode == "1" {
                    if value.keys.contains("data") {
                        if (value["data"] is [AnyHashable : Any] || value["data"] is [Any]) {
                            let data = value["data"]
                            success(data as Any)
                        } else {
                            success(value as Any)
                        }
                    } else {
                        success(value as Any)
                    }
                } else if responseCode == "-100" {
                    // token失效 退出登录
                    
                } else {
                    let errorDes = value["msg"] as? String
                    error(responseCode, errorDes ?? "网络连接错误!")
                }
                break
                
            case .failure(let err):
                error(customErrorCode, "网络连接错误!")
                print("error = \(err)")
                break
            }
        }
    }
    
    public func postRequestWith(url: String,
                                params:[String: Any]?,
                                success:@escaping ReqRsponseSuccess,
                                error:@escaping ReqResponseFail) {
        
        let  httpUrl = HTTPAPI.hostName + url
        // 设置请求头
        var headers = [String : String]()
        guard let token = BWUserDefaults.shareInstance.getUserToken() else {
            return
        }
        headers["token"] = token
        
        Alamofire.request(httpUrl, method: .post, parameters: params, encoding:URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let value = response.result.value as? [String: Any] else { break }
                let errorCode = String(value["code"] as? Int32 ?? -998)
                if errorCode == "1" {
                    if value.keys.contains("data") {
                        if (value["data"] is [AnyHashable : Any] || value["data"] is [Any]) {
                            let data = value["data"]
                            success(data as Any)
                        } else {
                            success(value as Any)
                        }
                    } else {
                        success(value as Any)
                    }
                } else if errorCode == "-100" {
                    // token失效 退出登录
                    
                } else {
                    let errorDes = value["msg"] as? String
                    error(errorCode, errorDes ?? "网络连接错误!")
                }
                break
                
            case .failure(let err):
                error(customErrorCode, "网络连接错误!")
                print("error = \(err)")
                break
            }
        }
    }
    
    public func requestWith(url:String,
                            httpMethod: HTTPMethod,
                            params:[String: Any]?,
                            success:@escaping ReqRsponseSuccess,
                            error:@escaping ReqResponseFail) {
        
        // 设置公共请求参数
        var updict = params
        let token = UserDefaults.standard.string(forKey: "token")
        if  token != nil {
            updict?["access_token"] = token
        }
        updict?["IOS"] = "app_os"
        updict?["app_version"] = "1.0"
        updict?["device_id"] = UIDevice.current.identifierForVendor?.uuidString
        
        switch httpMethod {
        case .get:
            getRequestWith(url: url, params: updict, success: success, error: error)
            
        case .post:
            postRequestWith(url: url, params: updict, success: success, error: error)
            
        default:
            break
            
        }
    }
    
    //切记私有化初始化方法，防止外部通过init直接创建实例。
    private override init() {
        
    }
}


///  网络状态监听
extension HttpNetwork {
    
    public func monitoringNetwork(networkStatus:@escaping NetworkStatus) {
        let reachability = NetworkReachabilityManager()
        reachability?.startListening()
        reachability?.listener = { [weak self] status in
            //守护。guard语句判断其后的表达式布尔值为false时，才会执行之后代码块里的代码，如果为true，则跳过整个guard语句
            guard  let weakSelf = self else { return }
            //?? 空和运算符 表示 reachability?.isReachable 如果不是有网 则为false；
            if reachability?.isReachable ?? false {
                switch status {
                case .notReachable:
                    weakSelf.htNetworkStatus = HTNetworkStatus.HttpNoReachable
                case .unknown:
                    weakSelf.htNetworkStatus = HTNetworkStatus.HttpUnknow
                case .reachable(.wwan):
                    weakSelf.htNetworkStatus = HTNetworkStatus.HttpWwan
                case .reachable(.ethernetOrWiFi):
                    weakSelf.htNetworkStatus = HTNetworkStatus.HttpWifi
                }
            } else {
                weakSelf.htNetworkStatus = HTNetworkStatus.HttpNoReachable
            }
            networkStatus(weakSelf.htNetworkStatus.rawValue)
        }
    }
    
    public func monitoringDataFormLocalWhenNetChanged() {
        self.monitoringNetwork{ (_) in
            
        }
    }
    
}

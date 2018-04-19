//
//  HynRequestManager.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/14.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit
import Alamofire
import EVReflection

enum HynRequestType:Int {
    case Get
    case Post
}

typealias hynSuccessed = (_ responseObject: AnyObject?) -> ()
typealias hynFaild = (_ error: NSError?) -> ()

//关于网络检测枚举
let ReachabilityStatusChangedNotification = "ReachabilityStatusChangedNotification"

enum ReachabilityType: CustomStringConvertible {
    case WWAN
    case WiFi
    
    var description: String {
        switch self {
        case .WWAN: return "WWAN"
        case .WiFi: return "WiFi"
        }
    }
}

enum ReachabilityStatus: CustomStringConvertible  {
    case Offline
    case Online(ReachabilityType)
    case Unknown
    
    var description: String {
        switch self {
        case .Offline: return "Offline"
        case .Online(let type): return "Online (\(type))"
        case .Unknown: return "Unknown"
        }
    }
}

//创建一个闭包(注:oc中block)
typealias sendVlesClosure = ([String : JSON]?, NSError?)->Void
typealias uploadClosure = ([String : JSON]?, NSError?,Int64?,Int64?,Int64?)->Void

class HynRequestManager: NSObject {
    
    static func request<T:NSObject>(type:HynRequestType ,urlString:RequestUrl, parameter:[String:AnyObject]?, block:@escaping ([T]?,NSError?)->Void) where T:EVReflectable {
        var param:[String:AnyObject] = ["login_member_id":login_member_id as AnyObject,"token":token as AnyObject]
        
        if (parameter != nil) {
            param += parameter!
        }
        
        switch type {
        case .Get:
            Alamofire.request(urlString, method: .get, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                guard (response.result.value != nil) else {
                    block(nil,response.result.error as NSError?)
                    return
                }
                let object:[T] = T.arrayFromJson(JSON(response.result.value as Any).dictionaryValue["data"]?.rawString())
                block(object,nil)
                
            })
            
        case .Post:
            Alamofire.request(urlString, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                guard (response.result.value != nil) else {
                    block(nil,response.result.error as NSError?)
                    return
                }
                let object:[T] = T.arrayFromJson(JSON(response.result.value as Any).dictionaryValue["data"]?.rawString())
                block(object,nil)
            })
        }
    }
    
    static func request<T:NSObject>(type:HynRequestType ,urlString:RequestUrl, parameter:[String:AnyObject]?, block:@escaping (T?,NSError?)->Void) where T:EVReflectable {
        var param:[String:AnyObject] = ["login_member_id":login_member_id as AnyObject,"token":token as AnyObject]
        
        if (parameter != nil) {
            param += parameter!
        }
        
        switch type {
        case .Get:
            Alamofire.request(urlString, method: .get, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                guard (response.result.value != nil) else {
                    block(nil,response.result.error as NSError?)
                    return
                }
                let object = T(json:JSON(response.result.value as Any).dictionaryValue["data"]?.rawString())
                block(object,nil)
                
            })
            
        case .Post:
            Alamofire.request(urlString, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                guard (response.result.value != nil) else {
                    block(nil,response.result.error as NSError?)
                    return
                }
                let object = T(json:JSON(response.result.value as Any).dictionaryValue["data"]?.rawString())
                block(object,nil)
            })
        }
    }
    //网络请求中的GET,Post
    static func request(type:HynRequestType ,urlString:RequestUrl, parameter:[String:AnyObject]?, block:@escaping sendVlesClosure) {
        
        var param:[String:AnyObject] = ["login_member_id":login_member_id as AnyObject,"token":token as AnyObject]
        
        if (parameter != nil) {
            param += parameter!
        }
        
        switch type {
        case .Get:
            Alamofire.request(urlString, method: .get, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                guard (response.result.value != nil) else {
                    block(nil,response.result.error as NSError?)
                    return
                }
                let swiftyJsonVar = JSON(response.result.value as Any)
                block(swiftyJsonVar.dictionary,nil)
                
            })
            
        case .Post:
            Alamofire.request(urlString, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                guard (response.result.value != nil) else {
                    block(nil,response.result.error as NSError?)
                    return
                }
                let swiftyJsonVar = JSON(response.result.value as Any)
                block(swiftyJsonVar.dictionary,nil)
            })
        }
    }

}

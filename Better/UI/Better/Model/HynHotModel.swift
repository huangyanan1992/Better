//
//  HynHotModel.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/17.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//
import Foundation
import EVReflection

class HynHotModel:EVObject {
    var status = 0
    var id = 0
    var type = 0
    var order = 0
    var target = ""
    var pic = ""
    var createTime = 0
    
    typealias result = ([HynHotModel]?, NSError?)->Void
    
    /// 数据请求
    ///
    /// - parameter result: [HynHotModel]?
    static func getBannerList(result:@escaping result) {
        HynRequestManager.request(type: .Post, urlString: RequestUrl.banner.rawValue, parameter: nil) { (hotArray:[HynHotModel]?, error) in
            guard (error != nil) else {
                result(hotArray,nil)
                return
            }
            result(nil, error)
        }
    }
}

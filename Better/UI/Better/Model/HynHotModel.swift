//
//  HynHotModel.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/17.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//
import Foundation

struct HynHotModel:HandyJSON {
    var status:Int?
    var id:Int?
    var type:Int?
    var order:Int?
    var target:String?
    var pic:String?
    var createTime:Int64?
    
    typealias result = ([HynHotModel]?, NSError?)->Void
    
    /// 数据请求
    ///
    /// - parameter result: [HynHotModel]?
    static func getBannerList(result:@escaping result) {
        HynRequestManager.request(type: .Post, urlString: RequestUrl.banner.rawValue, parameter: nil) { (resultJson, error) in
            guard (error != nil) else {
                let dataJson = resultJson?["data"]
                let dataArray = dataJson?.array
                var hotArray:[HynHotModel] = Array()
                if ((dataArray?.count) != nil) {
                    for dic:JSON in dataArray! {
                        let hotDic = NSDictionary.init(dictionary: dic.dictionaryObject!, copyItems: false)
                        let hotModel = JSONDeserializer<HynHotModel>.deserializeFrom(dict: hotDic)
                        hotArray.append(hotModel!)
                    }
                    
                }
                result(hotArray,nil)
                return
            }
            result(nil, error)
        }
    }
}

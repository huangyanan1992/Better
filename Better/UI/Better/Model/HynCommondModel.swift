//
//  HynCommondModel.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/26.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import Foundation
import UIKit

struct HynCommondModel:HandyJSON {
    /// 评论id
    var id:Int?
    /// 级别
    var level:Int?
    /// 楼层
    var floor:Int?
    /// 昵称
    var nickname:String?
    /// 创建时间
    var create_time:String?
    /// 点赞数
    var like_num:Int?
    /// 头像
    var avatar:String?
    /// 是否是频道管理员
    var is_channel_admin:Int?
    /// 用户id
    var member_id:Int?
    /// 回复几楼
    var to_floor:Int?
    /// 是否点赞
    var is_liked:Int?
    /// 内容
    var content:String? {
        didSet {
            let contentStr = NSString(cString: content!.cString(using: String.Encoding.utf8)!,
                                      encoding: String.Encoding.utf8.rawValue)
            contentHeight = getTextRectSize(text: contentStr!,font: UIFont.systemFont(ofSize: 13),size: CGSize(width: UIScreen.width()-30, height: 10000)).height
        }
    }
    /// 回复人姓名
    var to_member_name:String?
    /// 回复人id
    var to_member_id:Int?
    
    /// 内容高度
    var contentHeight:CGFloat?
    
    
    typealias result = ([HynCommondModel]?, NSError?)->Void
    static func getCommond(articleId:Int,pageSize:Int,result:@escaping result) {
        
        var param:[String:AnyObject] = Dictionary()
        param["pagesize"] = pageSize as AnyObject?
        param["article_id"] = articleId as AnyObject?
        param["member_id"] = login_member_id as AnyObject?
        
        HynRequestManager.request(type: .Post, urlString: RequestUrl.getComment.rawValue, parameter: param) { (resultJson, error) in
            
            let dataJson = resultJson?["data"]
            let array = dataJson?.array
            guard (array != nil) else {
                return
            }
            var commondArray:[HynCommondModel] = Array()
            for dic:JSON in array! {
                let commondDic = NSDictionary.init(dictionary: dic.dictionaryObject!, copyItems: false)
                var commondModel = JSONDeserializer<HynCommondModel>.deserializeFrom(dict: commondDic)
                commondModel?.content = commondModel?.content
                commondArray.append(commondModel!)
            }
            
            result(commondArray,nil)
            
        }
    }
    
}

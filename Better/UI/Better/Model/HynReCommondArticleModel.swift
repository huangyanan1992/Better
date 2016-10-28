//
//  HynHotListModel.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/18.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import Foundation
import UIKit


/// 获取图片
///
/// - parameter picStr: 图片字符
///
/// - returns: (宽，高)
func getPicSize(picStr:String) -> (width:CGFloat,height:CGFloat) {
    let sizeStr = picStr.components(separatedBy: "?").last
    guard (sizeStr != nil) else {
        return (0.0,0.0)
    }
    let sizeArray:[String] = (sizeStr?.components(separatedBy: "&"))!
    guard sizeArray.count == 2 else {
        return (0.0,0.0)
    }
    
    var width = CGFloat(Float((sizeArray.first?.components(separatedBy: "=").last)!)!)
    var height = CGFloat(Float((sizeArray.last?.components(separatedBy: "=").last)!)!)
    if width > 0 {
        height = UIScreen.width()*height/width
    }
    width = UIScreen.width()
    
    return (width,height)
}


/// 图片模型
struct picModel {
    /// 图片
    var pic:String?
    
    /// 图片大小
    var picSize:(width:CGFloat,height:CGFloat)?
    
}

struct HynReCommondArticleModel:HandyJSON {
    /// 频道名称
    var channel_name:String?
    /// 频道图片
    var channel_pic:String?
    /// 昵称
    var nickname:String?
    /// 浏览次数
    var view_num:Int?
    /// 头像
    var avatar:String?
    /// 是否是频道管理者 0：否 1：是
    var is_channel_admin:String?
    /// 频道id
    var channel_id:Int?
    /// 是否点赞 0：否 1：是
    var is_liked:Int?
    /// 成员id
    var member_id:Int?
    /// 内容
    var content:String? {
        didSet {
            let contentStr = NSString(cString: content!.cString(using: String.Encoding.utf8)!,
                     encoding: String.Encoding.utf8.rawValue)
            contentHeight = getTextRectSize(text: contentStr!,font: UIFont.systemFont(ofSize: 13),size: CGSize(width: UIScreen.width()-30, height: 10000)).height
        }
    }
    /// id
    var id:Int?
    /// 经度
    var geog_lat:String?
    /// 城市城市
    var loc_name2:String?
    /// 标题
    var title:String?
    /// 图片
    var pics:String? {
        didSet {
            let picStr = pics?.components(separatedBy: "|").first
            guard (picStr != nil) else {
                return
            }
            coverPic = picModel(pic: picStr, picSize: getPicSize(picStr: picStr!))
            
            picsModel = pics?.components(separatedBy: "|").map({ (picString) -> picModel in
                return picModel(pic: picString, picSize: getPicSize(picStr: picString!))
            })
        }
    }
    /// 具体地址
    var loc_name3:String?
    /// 级别
    var level:Int?
    /// 评论数
    var comment_num:Int?
    /// 点赞数
    var like_num:Int?
    /// 最新评论时间
    var new_comment_time:String?
    /// 纬度
    var geog_lon:String?
    /// 国家地址
    var loc_name1:String?
    /// 封面
    var coverPic:picModel?
    /// 图片
    var picsModel:[picModel]?
    /// 内容的高度
    var contentHeight:CGFloat?
    
    typealias result = ([HynReCommondArticleModel]?, NSError?)->Void
    
    static func getReCommendArticleMain(currentPage:Int,result:@escaping result)  {
        var param:[String:AnyObject] = Dictionary()
        param["currentPage"] = currentPage as AnyObject?
        param["member_id"] = login_member_id as AnyObject?
        
        HynRequestManager.request(type: .Post, urlString: RequestUrl.recommendArticle.rawValue, parameter: param) { (resultJson, error) in
            guard error == nil else {
                return result(nil,error)
            }
            let dataJson = resultJson?["data"]
            let dataArray = dataJson?.array
            var hotArray:[HynReCommondArticleModel] = Array()
            if ((dataArray?.count) != nil) {
                for dic:JSON in dataArray! {
                    let hotDic = NSDictionary.init(dictionary: dic.dictionaryObject!, copyItems: false)
                    var hotModel = JSONDeserializer<HynReCommondArticleModel>.deserializeFrom(dict: hotDic)
                    hotModel?.pics = hotModel?.pics
                    hotModel?.content = hotModel?.content
                    hotArray.append(hotModel!)
                }
                
            }
            result(hotArray,nil)
            
        }
    }
    
    static func getNewestArticle(result:@escaping result) {
        var param:[String:AnyObject] = Dictionary()
        param["pagesize"] = 15 as AnyObject?
        param["member_id"] = login_member_id as AnyObject?
        
        HynRequestManager.request(type: .Post, urlString: RequestUrl.getNewestArticle.rawValue, parameter: param) { (resultJson, error) in
            guard error == nil else {
                return result(nil,error)
            }
            let dataJson = resultJson?["data"]
            let dataArray = dataJson?.array
            var hotArray:[HynReCommondArticleModel] = Array()
            if ((dataArray?.count) != nil) {
                for dic:JSON in dataArray! {
                    let hotDic = NSDictionary.init(dictionary: dic.dictionaryObject!, copyItems: false)
                    var hotModel = JSONDeserializer<HynReCommondArticleModel>.deserializeFrom(dict: hotDic)
                    hotModel?.pics = hotModel?.pics
                    hotModel?.content = hotModel?.content
                    hotArray.append(hotModel!)
                }
                
            }
            result(hotArray,nil)
        }
    }
    
}

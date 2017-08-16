//
//  HynArticle.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/26.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import Foundation
import UIKit

struct HynArticle:HandyJSON {
    
    /// 频道照片
    var channel_pic:String?
    /// 频道名
    var channel_name:String?
    /// 昵称
    var nickname:String?
    /// 封面
    var avatar:String?
    /// 是否是频道管理员
    var is_channel_admin:Int?
    /// 是否收藏
    var isCollect:Int?
    /// 频道id
    var channel_id:Int?
    /// 用户id
    var member_id:Int?
    /// 内容
    var content:String? {
        didSet {
            let contentStr = NSString(cString: content!.cString(using: String.Encoding.utf8)!,
                                      encoding: String.Encoding.utf8.rawValue)
            contentHeight = getTextRectSize(text: contentStr!,font: UIFont.systemFont(ofSize: 13),size: CGSize(width: UIScreen.width()-30, height: 10000)).height
        }
    }
    /// 文章id
    var id:Int?
    /// 城市名
    var loc_name2:String?
    /// 纬度
    var geog_lat:String?
    /// 标题
    var title:String?
    /// 图片
    var pics:String? {
        didSet {
            let picStr = pics?.components(separatedBy: "|").first
            guard (picStr != nil) else {
                return
            }
            
            picsModel = pics?.components(separatedBy: "|").map({ (picString) -> picModel in
                return picModel(pic: picString, picSize: getPicSize(picStr: picString))
            })
        }
    }
    
    /// 图片
    var picsModel:[picModel]?
    /// 区名
    var loc_name3:String?
    /// 级别
    var level:Int?
    /// 是否置顶
    var is_top:Int?
    /// 创建时间
    var create_time:String?
    /// 评论数
    var comment_num:Int?
    /// 是否点赞
    var isLiked:Int?
    /// 是否推荐
    var is_recommend:Int?
    /// 点赞数
    var like_num:Int?
    /// 最新评论的时间
    var new_comment_time:String?
    /// 是否是精华
    var is_essence:Int?
    /// 纬度
    var geog_lon:String?
    /// 国家名
    var loc_name1:String?
    /// 内容的高度
    var contentHeight:CGFloat?
    
}

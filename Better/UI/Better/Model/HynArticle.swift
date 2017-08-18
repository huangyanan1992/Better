//
//  HynArticle.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/26.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import Foundation
import UIKit
import EVReflection

class HynArticle:EVObject {
    
    /// 频道照片
    var channel_pic = ""
    /// 频道名
    var channel_name = ""
    /// 昵称
    var nickname = ""
    /// 封面
    var avatar:String = ""
    /// 是否是频道管理员
    var is_channel_admin = 0
    /// 是否收藏
    var isCollect = 0
    /// 频道id
    var channel_id = 0
    /// 用户id
    var member_id = 0
    /// 内容
    var content = ""  {
        didSet {
            let contentStr = NSString(cString: content.cString(using: String.Encoding.utf8)!,
                                      encoding: String.Encoding.utf8.rawValue)
            contentHeight = Double(getTextRectSize(text: contentStr!,font: UIFont.systemFont(ofSize: 13),size: CGSize(width: UIScreen.width()-30, height: 10000)).height)
        }
    }
    /// 文章id
    var id = 0
    /// 城市名
    var loc_name2 = ""
    /// 纬度
    var geog_lat = ""
    /// 标题
    var title = ""
    /// 图片
    var pics = "" {
        didSet {
            let picStr = pics.components(separatedBy: "|").first
            guard (picStr != nil) else {
                return
            }
            
            picsModel = pics.components(separatedBy: "|").map({ (picString) -> picModel in
                return picModel(pic: picString, picSize: getPicSize(picStr: picString))
            })
        }
    }
    
    /// 图片
    var picsModel = [picModel]()
    /// 区名
    var loc_name3 = ""
    /// 级别
    var level = 0
    /// 是否置顶
    var is_top = 0
    /// 创建时间
    var create_time = ""
    /// 评论数
    var comment_num = 0
    /// 是否点赞
    var isLiked = 0
    /// 是否推荐
    var is_recommend = 0
    /// 点赞数
    var like_num = 0
    /// 最新评论的时间
    var new_comment_time = ""
    /// 是否是精华
    var is_essence = 0
    /// 纬度
    var geog_lon = ""
    /// 国家名
    var loc_name1 = ""
    /// 内容的高度
    var contentHeight = 0.0
    
}

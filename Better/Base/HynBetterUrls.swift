//
//  HynBetterUrls.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/18.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import Foundation

typealias RequestUrl = String
extension RequestUrl {
    static let banner = "http://www.iambetter.cn/v3/banner/getBannerList.do"
    static let recommendArticle = "http://www.iambetter.cn/v3/article/getRecommendArticleMain.do"
    static let cancelLikeORCollect = "http://www.iambetter.cn/v3/article/cancelLikeORCollect.do"
    static let likeAndCollect = "http://www.iambetter.cn/v3/article/likeAndCollect.do"
    static let getNewestArticle = "http://www.iambetter.cn/v3/article/getNewestArticleByTime.do"
    static let getArticle = "http://www.iambetter.cn/v3/article/getArticleById.do"
    static let getComment = "http://www.iambetter.cn/v3/comment/getCommentByTime.do"
}

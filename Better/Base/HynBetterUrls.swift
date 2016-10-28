//
//  HynBetterUrls.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/18.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import Foundation

enum RequestUrl:String {
    case banner = "http://www.iambetter.cn/v3/banner/getBannerList.do"
    case recommendArticle = "http://www.iambetter.cn/v3/article/getRecommendArticleMain.do"
    case cancelLikeORCollect = "http://www.iambetter.cn/v3/article/cancelLikeORCollect.do"
    case likeAndCollect = "http://www.iambetter.cn/v3/article/likeAndCollect.do"
    case getNewestArticle = "http://www.iambetter.cn/v3/article/getNewestArticleByTime.do"
    case getArticle = "http://www.iambetter.cn/v3/article/getArticleById.do"
    case getComment = "http://www.iambetter.cn/v3/comment/getCommentByTime.do"
}

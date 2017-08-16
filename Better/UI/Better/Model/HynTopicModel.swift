//
//  HynTopicModel.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/26.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import Foundation
import EVReflection

class HynTopicModel:EVObject {
    
    var article:HynArticle = HynArticle()
    var likes:[HynUserModel] = [HynUserModel]()
    
    
    typealias result = (HynTopicModel?, NSError?)->Void
    static func getArticleById(articleId:Int,result:@escaping result) {
        
        var param:[String:AnyObject] = Dictionary()
        param["mode"] = 2 as AnyObject?
        param["article_id"] = articleId as AnyObject?
        param["member_id"] = login_member_id as AnyObject?
        
        HynRequestManager.request(type: .Post, urlString: RequestUrl.getArticle.rawValue, parameter: param) { (resultJson, error) in
            
            let topicModel = HynTopicModel(json: resultJson?["data"]?.rawString())
            result(topicModel,nil)
            
        }
    }
}


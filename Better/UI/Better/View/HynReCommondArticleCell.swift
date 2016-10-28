//
//  HynReCommondArticleCell.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/18.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit
import Kingfisher

class HynReCommondArticleCell: UITableViewCell {
    
    /// 头像
    @IBOutlet weak var avatarImgView: UIImageView!
    /// 昵称
    @IBOutlet weak var nickNameLab: UILabel!
    /// 标题
    @IBOutlet weak var titleLab: UILabel!
    /// 内容
    @IBOutlet weak var contentLab: UILabel!
    /// 图片
    @IBOutlet weak var picImgView: UIImageView!
    /// 所在地区
    @IBOutlet weak var locationLab: UILabel!
    /// 浏览数
    @IBOutlet weak var view_numLab: UILabel!
    /// 点赞
    @IBOutlet weak var likeBtn: UIButton!

    /// 评论数
    @IBOutlet weak var commondNumLab: UILabel!
    
    
    /// 点赞需要修改model中数据，保证在上啦和下滑的过程中数据的正确性
    public typealias DidClick = (Int,Int) -> Void
    public var likeDidClick:DidClick?
    
    var reCommondArticleModel:HynReCommondArticleModel? {
        didSet {
            
            avatarImgView.kf.setImage(with: URL(string: (reCommondArticleModel?.avatar)!), placeholder: UIImage.init(named: "个人头像编辑"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
            
            nickNameLab.text = reCommondArticleModel?.nickname
            
            titleLab.text = reCommondArticleModel?.title
            if ((reCommondArticleModel?.content) != nil) {
                contentLab.attributedText = HynEmotionManager.shared.emoticonString(string: (reCommondArticleModel?.content)!, font: UIFont.systemFont(ofSize: 13),isToFloor: false)
            }
            
            let imageUrlStr = reCommondArticleModel?.pics?.components(separatedBy: "|").first
            picImgView.kf.setImage(with: URL(string: imageUrlStr!) as Resource?, placeholder: UIImage.init(named: "图片占位符"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
            
            locationLab.text = reCommondArticleModel?.loc_name3
            
            view_numLab.text = String(format: "%d",(reCommondArticleModel?.view_num)!)
            
            likeBtn.setTitle(String(format: "%d",(reCommondArticleModel?.like_num)!), for: UIControlState.normal)
            
            if reCommondArticleModel?.is_liked == 0 {
                likeBtn.setImage(UIImage.init(named: "真赞"), for: UIControlState.normal)
            }
            else {
                likeBtn.setImage(UIImage.init(named: "真赞-"), for: UIControlState.normal)
            }
            
            commondNumLab.text = String(format: "%d",(reCommondArticleModel?.comment_num)!)
            
        }
    }
    

    @IBAction func likeAction(_ sender: UIButton) {
        
        if reCommondArticleModel?.is_liked == 0 {
            
            var param:[String:AnyObject] = Dictionary()
            param["article_id"] = reCommondArticleModel?.id as AnyObject?
            param["member_id"] = member_id as AnyObject?
            param["channel_id"] = reCommondArticleModel?.channel_id as AnyObject?
            param["type"] = 2 as AnyObject?
            HynRequestManager.request(type: .Post, urlString: RequestUrl.likeAndCollect.rawValue, parameter: param, block: { (result, error) in
                guard (error == nil) else {
                    debugPrint("请求出错")
                    return
                }
                self.likeBtn.setImage(UIImage.init(named: "真赞-"), for: UIControlState.normal)
                self.reCommondArticleModel?.like_num = (self.reCommondArticleModel?.like_num)! + 1
                self.likeBtn.setTitle(String(format: "%d",(self.reCommondArticleModel?.like_num)!), for: UIControlState.normal)
                self.reCommondArticleModel?.is_liked = 1
                self.likeDidClick!(1,(self.reCommondArticleModel?.like_num)!)
            })
        }
        else {
            
            var param:[String:AnyObject] = Dictionary()
            param["article_id"] = reCommondArticleModel?.id as AnyObject?
            param["member_id"] = member_id as AnyObject?
            param["type"] = 2 as AnyObject?
            
            HynRequestManager.request(type: .Post, urlString: RequestUrl.cancelLikeORCollect.rawValue, parameter: param, block: { [weak self] (result, error) in
                guard (error == nil) else {
                    debugPrint("请求出错")
                    return
                }
                self?.likeBtn.setImage(UIImage.init(named: "真赞"), for: UIControlState.normal)
                self?.reCommondArticleModel?.like_num = (self?.reCommondArticleModel?.like_num)! - 1
                self?.likeBtn.setTitle(String(format: "%d",(self?.reCommondArticleModel?.like_num)!), for: UIControlState.normal)
                self?.reCommondArticleModel?.is_liked = 0
                self?.likeDidClick!(0,(self?.reCommondArticleModel?.like_num)!)
            })
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImgView.layer.cornerRadius = 20
        avatarImgView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

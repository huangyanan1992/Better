//
//  HynArticleCell.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/26.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class HynArticleCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nickName: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var article:HynArticle? {
        didSet {
            avatarImageView.kf.setImage(with: URL.init(string: (article?.avatar)!))
            nickName.text = article?.nickname
            titleLabel.text = article?.title
            contentLabel.attributedText = HynEmotionManager.shared.emoticonString(string: (article?.content)!, font: UIFont.systemFont(ofSize: 13),isToFloor: false)
            timeLabel.text = Date.dateByString(string: (article?.create_time)!).timesAgo()
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

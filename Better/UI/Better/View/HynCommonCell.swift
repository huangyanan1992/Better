//
//  HynCommonCell.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/26.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class HynCommonCell: UITableViewCell {
    @IBOutlet weak var avatarBtn: HynButton!
    @IBOutlet weak var nickNameBtn: UIButton!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commondBtn: UIButton!
    
    var commondModel:HynCommondModel? {
        didSet {
            guard (commondModel != nil) else {
                return
            }
            avatarBtn.kf.setImage(with: URL.init(string: (commondModel?.avatar)!), for: .normal)
            nickNameBtn.setTitle(commondModel?.nickname, for: .normal)
            floorLabel.text = String.init(format: "%d楼", (commondModel?.floor)!)
            if ((commondModel?.to_floor) != nil) && (commondModel?.to_floor)!>0 {
                commondModel?.content = String.init(format: "回复%d楼%@:%@", (commondModel?.to_floor)!,(commondModel?.to_member_name)!,(commondModel?.content)!)
                contentLabel.attributedText = HynEmotionManager.shared.emoticonString(string: (commondModel?.content)!, font: UIFont.systemFont(ofSize: 13),isToFloor: true)
            }
            else {
                contentLabel.attributedText = HynEmotionManager.shared.emoticonString(string: (commondModel?.content)!, font: UIFont.systemFont(ofSize: 13),isToFloor: false)
            }
            
            
            timeLabel.text = Date.dateByString(string: (commondModel?.create_time)!).timesAgo()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    @IBAction func commondAction(_ sender: UIButton) {
        
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        
    }
    
    @IBAction func reportAction(_ sender: UIButton) {
        
    }
    
    @IBAction func avatarAction(_ sender: UIButton) {
        
    }
    
    
    
}

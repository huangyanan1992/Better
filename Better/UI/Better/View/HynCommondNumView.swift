//
//  HynCommondCell.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/26.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class HynCommondNumView: UIView {
    
    var commond_num:Int? {
        didSet {
            guard (commond_num != nil) else {
                return
            }
            commond_numLabel.text = String.init(format: "%d条评论", commond_num!)
        }
    }
    
    @IBOutlet weak var commond_numLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

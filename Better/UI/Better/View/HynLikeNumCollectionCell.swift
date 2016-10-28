//
//  HynLikeNumCollectionCell.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/27.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class HynLikeNumCollectionCell: UICollectionViewCell {
    @IBOutlet weak var likeNumLabel: UILabel!
    
    var likeNum:Int? {
        didSet {
            guard (likeNum != nil) else {
                return
            }
            likeNumLabel.text = String.init(format: "%d", likeNum!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = self.bounds.width/2.0
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.gray.cgColor
        clipsToBounds = true
        
    }

}

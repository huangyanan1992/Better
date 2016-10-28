//
//  HynLikeMemberCollectionCell.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/26.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class HynLikeMemberCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    var userModel:HynUserModel? {
        didSet {
            guard ((userModel?.avatar) != nil) else {
                return
            }
            imgView.kf.setImage(with: URL.init(string: (userModel?.avatar)!))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.bounds.width/2.0
        self.clipsToBounds = true
    }

}

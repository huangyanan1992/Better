//
//  HynPhotoBrowserCell.swift
//  Better
//
//  Created by Huang Yanan on 2016/11/17.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class HynPhotoBrowserCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: 0, width: .screenWidth(), height: .screenHeight()-110)
    }

}

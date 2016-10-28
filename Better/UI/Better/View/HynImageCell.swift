//
//  HynImageCell.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/26.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class HynImageCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    var pic:picModel? {
        didSet {
            guard (pic?.pic != nil) else {
                return
            }
            imgView.kf.setImage(with: URL.init(string: (pic?.pic)!))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

//
//  HynAlbumCell.swift
//  Better
//
//  Created by Huang Yanan on 2016/11/8.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit
import Photos

class HynAlbumCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var count: UILabel!
    
    var albumItem:HynAlbumItem? {
        didSet {
            let asset:PHAsset = (albumItem?.fetchResult.lastObject)!
            
            let requestOPtion = PHImageRequestOptions.init()
            requestOPtion.resizeMode = .exact
            PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(width:70,height:70), contentMode: .aspectFit, options: requestOPtion) { [weak self] (image, nil) in
                
                self?.imgView.image = image
                
                
            }
            self.title.text = albumItem?.title
            self.count.text = String(format: "%d", (albumItem?.fetchResult.count)!)
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

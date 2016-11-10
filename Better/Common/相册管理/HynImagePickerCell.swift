//
//  HynImagePickerCell.swift
//  Better
//
//  Created by Huang Yanan on 2016/11/8.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit
import Photos

class HynImagePickerCell: UICollectionViewCell {

    @IBOutlet weak var pickerImage: UIImageView!
    @IBOutlet weak var checkSelected: UIImageView!
    @IBOutlet weak var selectedNum: UILabel!
    
    var imageId:PHImageRequestID?
    
    var count:Int = 0 {
        didSet {
            selectedNum.text = String(format: "%d", count+1)
        }
    }
    
    var imageIsSelectedClosure:((_ imgIsSelected:Bool,_ imageId:PHImageRequestID)->())?
    
    
    var assert:PHAsset? {
        didSet {
            guard (assert != nil) else {
                return
            }
            let requestOPtion = PHImageRequestOptions.init()
            requestOPtion.resizeMode = .exact
            imageId = PHCachingImageManager.default().requestImage(for: assert!, targetSize: CGSize(width:.screenWidth()/3.0,height:.screenWidth()/3.0), contentMode: .aspectFill, options: requestOPtion, resultHandler: { [weak self] (image, nil) in
                self?.pickerImage.image = image
            })
        }
    }
    
    
    var imgIsSelected:Bool = false {
        didSet {
            if imgIsSelected {
                imageIsSelected()
            }
            else {
                imageUnSelected()
            }
            guard (imageIsSelectedClosure != nil) && (imageId != nil) else {
                return
            }
            imageIsSelectedClosure!(imgIsSelected,imageId!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageUnSelected()
    }
    
    private func imageIsSelected() {
        checkSelected.isHidden = false
        selectedNum.isHidden = false
    }
    
    private func imageUnSelected() {
        checkSelected.isHidden = true
        selectedNum.isHidden = true
    }
    
    

}

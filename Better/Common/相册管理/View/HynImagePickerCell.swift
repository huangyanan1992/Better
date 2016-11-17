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
    @IBOutlet weak var selectedNum: UILabel!
    @IBOutlet weak var selectedBtn: UIButton!
    
    @IBOutlet weak var checkSelectBtn: UIButton!
    var imageId:PHImageRequestID?
    
    var selectImageClouser:((_ isSelected:Bool)->())?
    
    
    var count:Int = 0 {
        didSet {
            selectedNum.text = String(format: "%d", count+1)
        }
    }
    
    
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
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageUnSelected()
    }
    
    private func imageIsSelected() {
        checkSelectBtn.isHidden = false
        selectedNum.isHidden = false
        selectedBtn.isHidden = true
    }
    
    private func imageUnSelected() {
        checkSelectBtn.isHidden = true
        selectedNum.isHidden = true
        selectedBtn.isHidden = false
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        imgIsSelected = true
        guard (selectImageClouser != nil) else {
            return
        }
        selectImageClouser!(true)
        
    }
    
    @IBAction func checkSelectAction(_ sender: UIButton) {
        imgIsSelected = false
        guard (selectImageClouser != nil) else {
            return
        }
        selectImageClouser!(false)
    }

}

//
//  HynChannelViewController.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/14.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class HynChannelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func test(_ sender: UIButton) {
        ///获取相册权限
        HynCameraManager.requestPhotosAuthorizationStatus { [weak self] (_) in
            
            let imagePickerVC = HynImagePickerNavController.init()
            self?.present(imagePickerVC, animated: true, completion: nil)
            
            imagePickerVC.requestImages(images: { (asserts, images) in
                ///相册多图选择
                print(images)
            })
            
            imagePickerVC.requestCameraImage { (image) in
                ///相机拍照
                print(image)
            }
        }
        
    }

}

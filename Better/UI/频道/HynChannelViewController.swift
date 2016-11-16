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
        
        HynCameraManager.requestPhotosAuthorizationStatus { [weak self] (_) in
            
            let imagePickerVC = HynImagePickerNavController.init()
            self?.present(imagePickerVC, animated: true, completion: nil)
            
            imagePickerVC.imagesDidSelected = {
                print($0)
            }
            
            imagePickerVC.requestCameraImage { (image) in
                print(image)
            }
        }
        
    }

}

//
//  HynImagePickerController.swift
//  Better
//
//  Created by Huang Yanan on 2016/11/10.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class HynImagePickerController: UIImagePickerController {
    
    typealias finish = ((_ image:UIImage)->())
    
    fileprivate var finishImage:finish?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        sourceType = .camera
        
    }
    
    func requstImage(finish:@escaping finish) {
        finishImage = finish
    }
    
}

extension HynImagePickerController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        guard (finishImage != nil) else {
            return
        }
        
        finishImage!(gotImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

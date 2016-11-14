//
//  SQAlert_swift.swift
//  SQAlert
//
//  Created by Huang Yanan on 2016/9/26.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class SQAlert {
    
    static func showAlert(title:String,message:String,cancle:@escaping ()->(),confirm:@escaping ()->()) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancleAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.default) { (cancleAction) in
            cancle()
        }
        
        let confirmAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (confirmAction) in
            confirm()
        }
        
        alertVC.addAction(cancleAction)
        alertVC.addAction(confirmAction)
        
        guard (SQAlert.currentViewController() != nil) else {
            return
        }
        SQAlert.currentViewController()?.present(alertVC, animated: true
            , completion: nil)
        
        
    }
    
    static func currentViewController() -> UIViewController? {
        
        let appDelegate = UIApplication.shared.delegate
        guard appDelegate != nil else {
            return nil
        }
        
        let rootViewController = ((appDelegate?.window)!)!.rootViewController
        guard rootViewController != nil else {
            return nil
        }
        
        guard ((rootViewController?.presentedViewController) != nil) else {
            return rootViewController
        }
        return rootViewController?.presentedViewController
        
        
    }

}

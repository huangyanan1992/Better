//
//  HynCameraManager.swift
//  Better
//
//  Created by Huang Yanan on 2016/11/10.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit
import Photos

class HynCameraManager: NSObject {
    
    
    /// 获取相机权限
    ///
    /// - Parameters:
    ///   - complite: 获取权限成功回调
    static func requestCameraAuthorizationStatus(complite:@escaping (()->())) {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                complite()
            }
            else {
                SQAlert.showAlert(title: "提示", message: "照片权限没开启，请开启相册权限", cancle: {
                    
                }, confirm: {
                    UIApplication.shared.canOpenURL(URL.init(string: "prefs:root=Photos")!)
                })
            }
        }
    }

}

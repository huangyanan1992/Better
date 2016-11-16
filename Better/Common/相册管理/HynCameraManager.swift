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
    
    
    /// 获取相册权限
    ///
    /// - Parameters:
    ///   - complite: 获取权限成功回调
    static func requestPhotosAuthorizationStatus(complite:@escaping (()->())) {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                complite()
            }
            else {
                SQAlert.showAlert(title: "提示", message: "照片权限没开启，请开启相册权限", cancle: {
                    
                }, confirm: {
                    UIApplication.shared.canOpenURL(URL.init(string: "prefs:root=Privacy&path=PHOTOS")!)
                })
            }
        }
    }
    
    /// 获取相机权限
    ///
    /// - Parameter complite: 权限获取成功回调
    static func requestCameraAuthorizationStatus(complite:@escaping ()->()) {
        if hasCameraAuthorization() {
            complite()
        }
        
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (authorized) in
            
            if authorized {
                complite()
            }
            else {
                SQAlert.showAlert(title: "提示", message: "相机权限没开启，请开启相机权限", cancle: {
                    
                }, confirm: { 
                    
                })
            }
        })
    }
    
    static func hasCameraAuthorization()->Bool {
        
        let videoAuthStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if(videoAuthStatus == .restricted || videoAuthStatus == .denied) {
            // 未授权
            SQAlert.showAlert(title: "提示", message: "相机权限没开启，请开启相机权限", cancle: {
                
            }, confirm: { 
                UIApplication.shared.canOpenURL(URL.init(string: "prefs:root=Privacy&path=CAMERA")!)
            })
            return false
        }else{
            // 已授权
            return true
        }
    }

}

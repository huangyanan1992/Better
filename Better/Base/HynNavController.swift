//
//  HynNavController.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/27.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class HynNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self;
        self.interactivePopGestureRecognizer?.isEnabled = false;
        self.delegate = self;
        self.navigationBar.isTranslucent = false
    }

}

extension HynNavController:UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 1 {
            
            self.interactivePopGestureRecognizer?.isEnabled = true
        }
        else {
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        NotificationCenter.default.post(name: .EmotionWillHidden, object: nil, userInfo: nil)
    }

}

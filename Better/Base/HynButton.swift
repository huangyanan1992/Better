//
//  HynButton.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/26.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

@IBDesignable
class HynButton: UIButton {
    
    @IBInspectable var cornerRadios:CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadios
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor:UIColor? {
        didSet {
            self.layer.borderColor = borderColor?.cgColor
        }
    }
    
    

}

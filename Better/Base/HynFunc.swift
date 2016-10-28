//
//  HynFunc.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/18.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import Foundation
import UIKit

let member_id = 134633
let login_member_id = 134633

let token = "A493DCC8F0E200E1CD15BD0F9009FF7A"


/// 获取文字的高度
///
/// - parameter text: 文本
/// - parameter font: 字体
/// - parameter size: 大小
///
/// - returns: 文字的Rect
func getTextRectSize(text:NSString,font:UIFont,size:CGSize) -> CGRect {
    let attributes = [NSFontAttributeName: font]
    let option = NSStringDrawingOptions.usesLineFragmentOrigin
    let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
    return rect;
}


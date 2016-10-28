//
//  HynEmotionManager.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/19.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import Foundation
import UIKit

class HynEmotionManager {
    static let shared = HynEmotionManager()
    /// 表情包懒加载数组
    var imageDic:[String:String]?
    
    private init() {
        loadImageDic()
    }
}

extension HynEmotionManager {
    /// 将给定的字符串转换成属性文本
    ///
    /// - parameter string: 完整的字符串
    ///
    /// - returns: 属性文本
    func emoticonString(string: String,font: UIFont,isToFloor:Bool) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: string)
        //1.建立正则表达式，过滤所有的表情文字
        //() [] 都是正则表达式的关键字，如果需要参与匹配，需要转义
        let pattern = "\\[.*?\\]"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else{
            return attrString
        }
        
        //2.匹配所有项
        let matches = regx.matches(in: string, options: [], range: NSRange(location: 0, length: attrString.length))
        
        //3.遍历所有匹配结果
        for m in matches.reversed() {
            let r = m.rangeAt(0)
            let subStr = (attrString.string as NSString).substring(with: r)
            
            //使用subStr 查找对应的表情符号
            if let em = HynEmotionManager.shared.findEmoticon(string: subStr) {
                //使用表情符号中的属性文本，替换原有的属性文本内容
                attrString.replaceCharacters(in: r, with: imageText(font: font,image: em))
            }
        }
        
        
        //4.统一设置一遍字符串的属性
        if isToFloor {
            let toFloorStr = string.components(separatedBy: ":").first
            attrString.addAttributes([NSFontAttributeName: font], range: NSRange(location: 0, length:2))
            attrString.addAttributes([NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor(red: 254/255.0, green: 196/255.0, blue: 62/255.0, alpha: 1.0)], range: NSRange(location: 2, length:(toFloorStr?.characters.count)!-2))
            attrString.addAttributes([NSFontAttributeName: font], range: NSRange(location: (toFloorStr?.characters.count)!, length: attrString.length-(toFloorStr?.characters.count)!))
        }
        else {
            attrString.addAttributes([NSFontAttributeName: font], range: NSRange(location: 0, length: attrString.length))
        }
        return attrString
    }
    
    func findEmoticon(string:String?) -> UIImage? {
        
        guard (imageDic != nil) && (string != nil) else {
            return nil
        }
        return UIImage.init(named: (imageDic?[string!])!)
        
    }
    
    //根据当前的图像，生成图像的属性文本
    func imageText(font:UIFont,image:UIImage) -> NSAttributedString {
        
        //创建文本附件 -图像
        let attachment = NSTextAttachment()
        attachment.image = image
        //lineHeight 大致和字体大小相等
        let height = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -2, width: height, height: height)
        //返回图像属性文本
        return NSAttributedString(attachment: attachment)
    }
}

extension HynEmotionManager {
    
    /// 获取本地表情资源
    func loadImageDic() {
        
        let expressionImagewodePath = Bundle.main.path(forResource: "expressionImagewode", ofType: "plist")
        let signInFacePath = Bundle.main.path(forResource: "SignInFace", ofType: "plist")
        let faceNamePlistPath = Bundle.main.path(forResource: "FaceNamePlist", ofType: "plist")
        let betterFaceNamePath = Bundle.main.path(forResource: "BetterFaceName", ofType: "plist")
        
        var expression = NSDictionary(contentsOfFile: expressionImagewodePath!) as! [String:String]
        let signInFace = NSDictionary(contentsOfFile: signInFacePath!) as! [String:String]
        let faceName = NSDictionary(contentsOfFile: faceNamePlistPath!) as! [String:String]
        let betterFace = NSDictionary(contentsOfFile: betterFaceNamePath!) as! [String:String]
        
        expression += signInFace
        expression += faceName
        expression += betterFace
        
        imageDic = expression
        
    }
}

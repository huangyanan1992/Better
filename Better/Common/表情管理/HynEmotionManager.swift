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
    var imageDic:[String:String]?///所有表情集合
    var expressionDic:[String:String]?///emoji表情
    var signInFaceDic:[String:String]?///签到表情
    var faceNameDic:[String:String]?///emoji表情 同expressionDic
    var betterFaceDic:[String:String]?///better专属表情包
    
    ///剔除重复的后的表情
    var betterArray:[String] = Array()
    var signInArray:[String] = Array()
    var faceNameArray:[String] = Array()
    
    private init() {
        loadImage()
    }
}

extension HynEmotionManager {
    /// 删除最后一个表情字符
    ///
    /// - parameter string: 需要删除的字符串
    ///
    /// - returns: 删除最后一个表情后的字符串
    func deleteLastEmotionStr(string:String) -> String {
        let pattern = "\\[.*?\\]"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else{
            return ""
        }
        var resultStr = string
        let matches = regx.matches(in: string, options: [], range: NSRange(location: 0, length:string.characters.count))
        var i = 0
        for m in matches {
            i = i+1
            ///如果是最后一个则删除之
            if matches.count == i {
                let r = m.rangeAt(0)
                let subStr = (string as NSString).substring(with: r)
                resultStr = (resultStr as NSString).substring(to: resultStr.characters.count-subStr.characters.count)
            }
        }
        return resultStr
    }
    
    /// 光标前的字符是否是表情
    ///
    /// - parameter string: 光标前的字符
    ///
    /// - returns: true->是，false->否
    func lastIsEmotionStr(string:String)->Bool {
        let pattern = "\\[.*?\\]$"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else{
            return false
        }
        let matches = regx.matches(in: string, options: [], range: NSRange(location: 0, length:string.characters.count))
        if matches.count == 0 {
            return false
        }
        else {
            return true
        }
    }
    
    /// 将给定的字符串转换成属性文本
    ///
    /// - parameter string: 完整的字符串, 
    /// - parameter font: 字体
    /// - parameter isToFloor: 是否是回复楼层
    ///
    /// - returns: 带表情图片的富文本
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
            if let em = HynEmotionManager.shared.findEmoticon(key: subStr) {
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
    
    ///  根据key查找对应的表情图片
    ///
    /// - parameter key: 表情图片的key值
    ///
    /// - returns: 表情图片
    func findEmoticon(key:String?) -> UIImage? {
        guard (imageDic != nil) && (key != nil) else {
            return nil
        }
        let image = UIImage.init(named: (imageDic?[key!])!)
        return image
        
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
    func loadImage() {
        
        let expressionImagewodePath = Bundle.main.path(forResource: "expressionImagewode", ofType: "plist")
        let signInFacePath = Bundle.main.path(forResource: "SignInFace", ofType: "plist")
        let faceNamePlistPath = Bundle.main.path(forResource: "FaceNamePlist", ofType: "plist")
        let betterFaceNamePath = Bundle.main.path(forResource: "BetterFaceName", ofType: "plist")
        
        var expression = NSDictionary(contentsOfFile: expressionImagewodePath!) as! [String:String]
        expressionDic = expression
        let signInFace = NSDictionary(contentsOfFile: signInFacePath!) as! [String:String]
        signInFaceDic = signInFace
        let faceName = NSDictionary(contentsOfFile: faceNamePlistPath!) as! [String:String]
        faceNameDic = faceName
        let betterFace = NSDictionary(contentsOfFile: betterFaceNamePath!) as! [String:String]
        betterFaceDic = betterFace
        
        expression += signInFace
        expression += faceName
        expression += betterFace
        
        imageDic = expression
        
        
        ///由于plist文件中的表情是重复的，所以需要剔除key值是：[表情]的，同时在每一页最后一个添加删除键
        var i = 0
        for emotionName in (betterFaceDic?.keys)! {
            i = i + 1
            betterArray.append(emotionName)
        }
        
        betterArray = betterArray.filter { (str) -> Bool in
            return !str.contains("b_")
        }
        
        i = 0
        for emotionName in (signInFaceDic?.keys)! {
            i = i + 1
            signInArray.append(emotionName)
        }
        
        signInArray = signInArray.filter { (str) -> Bool in
            return !str.contains("n_")
        }
        
        i = 0
        for emotionName in (faceNameDic?.keys)! {
            i = i + 1
            faceNameArray.append(emotionName)
        }
        
    }
}

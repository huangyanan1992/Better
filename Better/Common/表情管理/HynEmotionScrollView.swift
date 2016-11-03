//
//  HynEmotionScrollView.swift
//  Better
//
//  Created by Huang Yanan on 2016/11/1.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

let scrollSpace:CGFloat = 40


let itemWidth:CGFloat = (.screenWidth()-scrollSpace)/9
let itemHeight:CGFloat = (.screenWidth()-scrollSpace)/9

let itemHorizontalSpace:CGFloat = 5
let itemVerticalSpace:CGFloat = 5



class HynEmotionScrollView: UIScrollView {
    
    var pageNum:Int = 0
    
    var betterDic = HynEmotionManager.shared.imageDic
    var emotionDidClick:((_ string:String)->())?
    
    var dataArray:[String] = Array() {
        didSet {
            for view in subviews {
                view.removeFromSuperview()
            }
            betterDic?["[删除]"] = "删除"
            
            pageNum = dataArray.count/27+1
            self.contentSize = CGSize(width: CGFloat(pageNum)*(.screenWidth()-scrollSpace), height: itemHeight*3)
            
            for i in 0..<dataArray.count {
                
                let page = i/27
                let colm = (i-page*27)%9//列
                let row = (i-page*27)/9//行
                let pageWidth = CGFloat(page)*(.screenWidth()-scrollSpace)//页宽
                let x = itemHorizontalSpace+CGFloat(colm)*itemWidth + pageWidth
                let y = itemVerticalSpace+CGFloat(row)*itemHeight
                
                
                let button = UIButton.init(frame: CGRect(x: x, y: y, width: itemWidth-itemHorizontalSpace*2, height: itemHeight-itemVerticalSpace*2))
                button.tag = i
                let key = dataArray[i]
                
                if betterDic?[key] != nil {
                    button.setImage(UIImage.init(named: (betterDic?[key])!), for: .normal)
                }
                
                button.addTarget(self, action: #selector(emotionAction(button:)), for: .touchUpInside)
                addSubview(button)
                
            }
        }
    }
    
    @objc func emotionAction(button:UIButton) {
        print(dataArray[button.tag])
        if (emotionDidClick != nil) {
            emotionDidClick!(dataArray[button.tag])
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        isPagingEnabled = true
        alwaysBounceHorizontal = true
        alwaysBounceVertical = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

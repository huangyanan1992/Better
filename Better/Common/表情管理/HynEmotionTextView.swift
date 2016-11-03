//
//  HynEmotionTextField.swift
//  Better
//
//  Created by Huang Yanan on 2016/11/1.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit
import YYText

let emotionTextFieldHeight:CGFloat = 44


class HynEmotionTextView: UIView {

    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var emotionBtn: UIButton!
        
    @IBOutlet weak var yy_textView: YYTextView!
    
    var emotionDidClick:((_ isSelected:Bool)->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        frame = CGRect(x: 0, y: 0, width: .screenWidth(), height: emotionTextFieldHeight)
        yy_textView.delegate = self
        yy_textView.layer.cornerRadius = 5
        yy_textView.layer.borderColor = UIColor.gray.cgColor
        yy_textView.layer.borderWidth = 0.5
        
    }
    
    @IBAction func emotionAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            yy_textView.resignFirstResponder()
            emotionBtn.setImage(UIImage.init(named: "键盘"), for: .normal)
        }
        else {
            yy_textView.becomeFirstResponder()
            emotionBtn.setImage(UIImage.init(named: "可发布表情"), for: .normal)
            return
            
        }
        guard (emotionDidClick != nil) else {
            return
        }
        emotionDidClick!(emotionBtn.isSelected)
        
    }
    
    @IBAction func photosAction(_ sender: UIButton) {
        
    }

}

typealias EmotionTextFieldDelegate = HynEmotionTextView
extension EmotionTextFieldDelegate:YYTextViewDelegate {
    
    ///键盘弹起，按钮显示成可发布表情，没被选中
    
    func textViewShouldBeginEditing(_ textView: YYTextView) -> Bool {
        emotionBtn.isSelected = false
        emotionBtn.setImage(UIImage.init(named: "可发布表情"), for: .normal)
        return true
    }
    
}

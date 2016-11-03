//
//  HynEmotionKeyBoardManager.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/28.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit
import YYText

class HynEmotionKeyBoard: UIView {
    
    var bottomView:HynEmotionBottomView?
    
    var scrollView:HynEmotionScrollView?
    var emotionTextView:HynEmotionTextView?
    
    var superFrame:CGRect?//视图初始化时的frame
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        superFrame = frame
        backgroundColor = UIColor.white
        
        createSubViews()
        addObserver()
        self.viewController()?.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver()
    }

}

///监听键盘，控制表情键盘和系统键盘的展示和收起
typealias EmotionKeyBoardChange = HynEmotionKeyBoard
extension EmotionKeyBoardChange {
    
    fileprivate func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notify:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notify:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(popNotify), name: .EmotionWillHidden, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: .EmotionWillHidden, object: nil)
    }
    
    @objc private func popNotify() {
        
        UIApplication.shared.keyWindow?.endEditing(true)
        self.frame = CGRect(x: 0, y: .screenHeight()-emotionTextFieldHeight-64, width: .screenWidth(), height: itemHeight*3+emotionKeyBoardBottomHeight+emotionTextFieldHeight)
        self.emotionTextView?.frame = CGRect(x: 0, y: 0, width: .screenWidth(), height: emotionTextFieldHeight)
    }
    
    @objc private func keyBoardWillShow(notify:Notification) {
        let userInfo = notify.userInfo
        let keyBoardFrame = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyBoardHeight = keyBoardFrame.size.height
        UIView.animate(withDuration: 0.25) {
            ///键盘弹起，修改当前视图的Y坐标，使得emotionTextField刚好在键盘上方
            let y = .screenHeight() - keyBoardHeight - emotionTextFieldHeight-64
            self.frame = CGRect(x: 0, y: y, width: .screenWidth(), height: keyBoardFrame.size.height+emotionTextFieldHeight)
            self.emotionTextView?.frame = CGRect(x: 0, y: 0, width: .screenWidth(), height: emotionTextFieldHeight)
        }
        print(keyBoardHeight)
    }
    
    @objc private func keyBoardWillHide(notify:Notification) {
        keyBoardHide()
    }
}



typealias EmotionCreateSubViews = HynEmotionKeyBoard
extension EmotionCreateSubViews {
    
    fileprivate func createSubViews() {
        creatScrollView()
        creatEmotionTextField()
        creatBottomView()
    }
    
    private func creatEmotionTextField() {
        
        emotionTextView = HynEmotionTextView.initWithNib() as! HynEmotionTextView?
        emotionTextView?.frame = CGRect(x: 0, y: 0, width: .screenWidth(), height: emotionTextFieldHeight)
        emotionTextView?.emotionDidClick = { isSelected in
            if isSelected {
                self.keyBoardHide()
            }
            else {
                self.keyBoardAllHide()
            }
        }
        
        addSubview(emotionTextView!)
    }
    
    private func creatScrollView() {
        
        let scrollBgView = UIView.init(frame: CGRect(x: 0, y: emotionTextFieldHeight, width: .screenWidth(), height: itemHeight*3))
        scrollBgView.backgroundColor = HynThemeManager.shared.backgroundColor
        addSubview(scrollBgView)
        
        scrollView = HynEmotionScrollView.init(frame: CGRect(x: scrollSpace/2, y: 0, width: .screenWidth()-scrollSpace, height: itemHeight*3))
        scrollView?.dataArray = HynEmotionManager.shared.betterArray
        scrollView?.emotionDidClick = { emotionStr in
            if emotionStr == "[删除]" {
                guard ((self.emotionTextView?.yy_textView.text) != nil) else {
                    return
                }
                self.emotionTextView?.yy_textView.deleteBackward()
                
            }
            else {
                let text = NSMutableAttributedString.init(attributedString: (self.emotionTextView?.yy_textView.attributedText)!) 
                
                let emotionText = NSMutableAttributedString.init(string: emotionStr)
                
                emotionText.yy_setTextBinding(YYTextBinding.init(deleteConfirm: false), range: emotionText.yy_rangeOfAll())
                text.append(emotionText)
                text.append(NSMutableAttributedString.init(string: ""))
                
                self.emotionTextView?.yy_textView.attributedText = text
            }
            
        }
        scrollBgView.addSubview(scrollView!)
        
    }
    
    private func creatBottomView() {
        
        bottomView = HynEmotionBottomView.initWithNib() as! HynEmotionBottomView?
        bottomView?.frame = CGRect(x: 0, y: (self.superFrame?.size.height)!-emotionKeyBoardBottomHeight, width: .screenWidth(), height: emotionKeyBoardBottomHeight)
        addSubview(bottomView!)
        
        bottomView?.betterDidClick = {
            self.scrollView?.dataArray = HynEmotionManager.shared.betterArray
        }
        
        bottomView?.signInDidClick = {
            self.scrollView?.dataArray = HynEmotionManager.shared.signInArray
        }
        
        bottomView?.faceNameDidClick = {
            self.scrollView?.dataArray = HynEmotionManager.shared.faceNameArray
        }
        
    }
}

typealias EmotionKeyBoardFrameChange = HynEmotionKeyBoard
extension EmotionKeyBoardFrameChange {
    ///隐藏表情键盘和输入法键盘
    func keyBoardAllHide() {
        UIApplication.shared.keyWindow?.endEditing(true)
        UIView.animate(withDuration: 0.25, animations: {
            self.frame = CGRect(x: 0, y: .screenHeight()-emotionTextFieldHeight-64, width: .screenWidth(), height: itemHeight*3+emotionKeyBoardBottomHeight+emotionTextFieldHeight)
            self.emotionTextView?.frame = CGRect(x: 0, y: 0, width: .screenWidth(), height: emotionTextFieldHeight)
        })
    }
    
    ///隐藏输入法键盘
    func keyBoardHide() {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.frame = CGRect(x: 0, y: .screenHeight()-(self.superFrame?.size.height)!-64, width: .screenWidth(), height: itemHeight*3+emotionKeyBoardBottomHeight+emotionTextFieldHeight)
            self.emotionTextView?.frame = CGRect(x: 0, y: 0, width: .screenWidth(), height: emotionTextFieldHeight)
            }) { (_) in
                self.bottomView?.frame = CGRect(x: 0, y: (self.superFrame?.size.height)!-emotionKeyBoardBottomHeight, width: .screenWidth(), height: emotionKeyBoardBottomHeight)
        }
    }
}

typealias EmotionNavigationDelegate = HynEmotionKeyBoard
extension EmotionNavigationDelegate:UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        keyBoardAllHide()
        return true
    }
}


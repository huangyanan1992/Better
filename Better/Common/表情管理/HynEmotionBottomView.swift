//
//  HynEmotionBottomView.swift
//  Better
//
//  Created by Huang Yanan on 2016/11/2.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

let emotionKeyBoardBottomHeight:CGFloat = 30

class HynEmotionBottomView: UIView {

    @IBOutlet weak var betterBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var faceNameBtn: UIButton!
    
    var betterDidClick:(()->())?
    var signInDidClick:(()->())?
    var faceNameDidClick:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: 0, width: .screenWidth(), height: emotionKeyBoardBottomHeight)
        betterAction(betterBtn)
    }

    @IBAction func betterAction(_ sender: UIButton) {
        print("betterAction")
        UIView.animate(withDuration: 0.25) {
            self.betterBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.signInBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.faceNameBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        guard (betterDidClick != nil) else {
            return
        }
        betterDidClick!()
        
    }
    @IBAction func signInAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.betterBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.signInBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.faceNameBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        print("signInAction")
        
        guard (signInDidClick != nil) else {
            return
        }
        signInDidClick!()
    }
    @IBAction func faceNameAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.betterBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.signInBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.faceNameBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        print("faceNameAction")
        
        guard (faceNameDidClick != nil) else {
            return
        }
        faceNameDidClick!()
    }
}

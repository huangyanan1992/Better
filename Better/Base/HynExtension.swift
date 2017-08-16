//
//  HynUtil.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/17.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import Foundation
import UIKit
import EVReflection

extension UIViewController {
    
    /// 返回键
    func setUpBackBtn() {
        let backImage = UIImage(named: "NaviBtn_Back")!
        let backImageHigh = UIImage(named: "NaviBtn_Back_H")!
        
        let backBtn = UIButton(type: UIButtonType.custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: backImage.size.width, height: backImage.size.height)
        backBtn.setImage(backImage, for: UIControlState.normal)
        backBtn.setImage(backImageHigh, for: UIControlState.highlighted)
        backBtn.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        self.setLeftBarButtonItem(barButtonItem: UIBarButtonItem.init(customView: backBtn))
    }
    
    @objc func back() {
        if (self.navigationController?.viewControllers.count)! > 1 {
            navigationController?.popViewController(animated: true)
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func setLeftBarButtonItem(barButtonItem:UIBarButtonItem) {
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacer.width = 0
        self.navigationItem.leftBarButtonItems = Array.init(arrayLiteral: negativeSpacer,barButtonItem)
    }
    
    func setRightBarButtonItem(barButtonItem:UIBarButtonItem) {
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacer.width = 0
        self.navigationItem.rightBarButtonItems = Array.init(arrayLiteral: negativeSpacer,barButtonItem)
    }
    
    func leftBarButtonItem() -> UIBarButtonItem? {
        return self.navigationItem.leftBarButtonItems?.last
    }
    
    func rightBarButtonItem() -> UIBarButtonItem? {
        return self.navigationItem.leftBarButtonItems?.last
    }
    
    
}

extension NSObject {
    
    static func className() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
}

extension UIScreen {
    
    static func width() -> CGFloat {
        return self.main.bounds.width
    }
    
    static func height() -> CGFloat {
        return self.main.bounds.height
    }
}

@IBDesignable
extension UIView {
    
    
    /// 圆角
    @IBInspectable var hyn_cornerRadios:CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set(newValue) {
            self.layer.cornerRadius = newValue
        }
    }
    
    /// 边框宽度
    @IBInspectable var hyn_borderWidth:CGFloat {
        get {
            return self.layer.borderWidth
        }
        
        set(newValue) {
            self.layer.borderWidth = newValue
        }
    }
    
    /// 边框颜色
    @IBInspectable var hyn_borderColor:UIColor {
        get {
            guard (self.layer.borderColor != nil) else {
                return UIColor.clear
            }
            return UIColor.init(cgColor: self.layer.borderColor!)
        }
        set(newValue) {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    func viewController() -> UIViewController? {
        var next = self.next
        guard (next != nil) else {
            return nil
        }
        repeat{
            if next!.isKind(of: UIViewController.self) {
                if next!.isKind(of: UIViewController.self) {
                    return (next as? UIViewController)!
                }
            }
            next = next!.next
        } while next != nil
        return UIViewController()
    }
    
    func isVisible() -> Bool {
        guard (self.viewController() != nil) else {
            return false
        }
        print(self.viewController()!.isViewLoaded && (self.window != nil))
        return self.viewController()!.isViewLoaded && (self.window != nil)
    }
    
    func isDisPlayInScreen() -> Bool {
        return false
    }
}

// MARK: - 从nib文件加载UIView
extension UIView {
    
    static func initWithNib() -> UIView? {
        
        let nib = UINib.init(nibName: String.init(describing: self), bundle: nil)
        let views = nib.instantiate(withOwner: nil, options: nil)
        for view in views {
            if (view as AnyObject).isMember(of: self) {
                return view as? UIView
            }
            assert(false,"\(String(describing: self)).xib not exist")
        }
        return nil
    }
    
    func bottom() -> CGFloat {
        return self.frame.origin.y+self.bounds.size.height
    }
}

extension UITableViewCell {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

extension CGFloat {
    
    static func screenWidth() -> CGFloat {
       return  UIScreen.main.bounds.size.width
    }
    
    static func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
}

func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

//
//  HynRefreshFooter.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/20.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class HynRefreshFooter: UIView {
    
    @IBOutlet weak var footerContentLabel: UILabel!

    @IBOutlet weak var footerActivityIndicator: UIActivityIndicatorView!
    
    var refreshStatus:HynRefreshFooterStatus = .normal {
        didSet {
            switch refreshStatus {
            case .normal:
                setNormalStatus()
                break
            case .waitRefresh:
                setWaitRefreshStatus()
                break
            case .refreshing:
                setRefreshing()
                break
            case .over:
                setOver()
                break
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: 25, width: UIScreen.main.bounds.width, height: 50)
    }
}

// MARK: - 上拉状态切换
extension HynRefreshFooter {
    
    fileprivate func setNormalStatus() {
        
        if footerActivityIndicator.isAnimating {
            footerActivityIndicator.stopAnimating()
        }
        footerActivityIndicator.isHidden = true
        footerContentLabel.text = "上拉加载更多"
        
    }
    
    fileprivate func setWaitRefreshStatus() {
        
        if footerActivityIndicator.isAnimating {
            footerActivityIndicator.stopAnimating()
        }
        footerActivityIndicator.isHidden = true
        
        footerContentLabel.text = "松开加载更多数据"
        
    }
    
    fileprivate func setRefreshing() {
        
        footerActivityIndicator.isHidden = false
        footerActivityIndicator.startAnimating()
        
        footerContentLabel.text = "正在加载更多数据...哇咔咔"
    }
    
    fileprivate func setOver() {
        
        if footerActivityIndicator.isAnimating {
            footerActivityIndicator.stopAnimating()
        }
        footerActivityIndicator.isHidden = true
        footerContentLabel.text = "无更多数据"
        
    }
    
}

//
//  HynRefreshHeader.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/20.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class HynRefreshHeader: UIView {
    
    @IBOutlet weak var refreshDownImageView: UIImageView!
    @IBOutlet weak var headerActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lastRefreshTimeLabel: UILabel!

    @IBOutlet weak var headerContentLabel: UILabel!
    
    private typealias HynHeaderClosure = ()->Void
    
    let lastRefreshTimeKey = "LastRefreshTime"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        setLastRefreshTime()
    }
    
    static func header() -> HynRefreshHeader {
        return HynRefreshHeader.initWithNib() as! HynRefreshHeader
    }
    
    func headerRefresh(headerRefresh:HynHeaderClosure) {
        
    }
    
    var refreshStatus:HynRefreshHeaderStatus = .normal {
        didSet {
            switch refreshStatus {
            case .normal:
                setNormalStatus()
                break
            case .waitRefresh:
                setWaitRefreshStatus()
                break
            case .refreshing:
                setRefreshingStatus()
            }
        }
    }
    
}

/// 设置最后更新时间
extension HynRefreshHeader {
    
    func setLastRefreshTime() {
        if (UserDefaults.standard.value(forKey: lastRefreshTimeKey) != nil) {
            let date = UserDefaults.standard.value(forKey: lastRefreshTimeKey) as! Date
            if date.isToday() {
                lastRefreshTimeLabel.text = String(format: "最后更新：今天 %@", date.timeString())
            }
            else {
                lastRefreshTimeLabel.text = String(format: "最后更新：%@", date.dateTimeString3())
            }
        }
    }
    
}

// MARK: - 下拉状态切换
extension HynRefreshHeader {
    
    fileprivate func setNormalStatus() {
        
        if headerActivityIndicator.isAnimating {
            headerActivityIndicator.stopAnimating()
        }
        headerActivityIndicator.isHidden = true
        
        headerContentLabel.text = "下拉刷新"
        refreshDownImageView.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: {
            self.refreshDownImageView.transform = CGAffineTransform.identity
        })
    }
    
    fileprivate func setWaitRefreshStatus() {
        
        if headerActivityIndicator.isAnimating {
            headerActivityIndicator.stopAnimating()
        }
        headerActivityIndicator.isHidden = true
        
        headerContentLabel.text = "松松松..手，开始刷新"
        refreshDownImageView.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: {
            self.refreshDownImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))
            
        })
    }
    
    fileprivate func setRefreshingStatus() {
        
        headerActivityIndicator.isHidden = false
        headerActivityIndicator.startAnimating()
        
        headerContentLabel.text = "正在刷新哇咔咔"
        
        UserDefaults.standard.set(Date(), forKey: lastRefreshTimeKey)
        if UserDefaults.standard.synchronize() {
            setLastRefreshTime()
        }
        
        refreshDownImageView.isHidden = true
        
    }
}

//
//  HynNewestViewController.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/19.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class HynNewestViewController: UITableViewController {
    
    var dataArray:[HynReCommondArticleModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        requstData()
        addRefresh()
    }
    
    func setUpTableView() {
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(UINib.init(nibName: HynHotBannerCell.className(), bundle: nil), forCellReuseIdentifier: HynHotBannerCell.className())
        tableView.register(UINib.init(nibName: HynReCommondArticleCell.className(), bundle: nil), forCellReuseIdentifier: HynReCommondArticleCell.className())
        
    }
    
}

/// 下拉刷新
extension HynNewestViewController {

    func addRefresh() {
        
        //tableView.addRefreshHeader { [weak self] () in
          //  self?.requstData()
        //}
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 254/255.0, green: 196/255.0, blue: 62/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            self?.requstData()
            
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(tableView.backgroundColor!)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    @objc fileprivate func headerRefresh() {
        
        //self.tableView.hyn_headerEndRefreshing()
        self.tableView.dg_stopLoading()
        self.tableView.reloadData()
    }
    
}

/// 数据请求
extension HynNewestViewController {
    
    func requstData() {
        
        HynReCommondArticleModel.getNewestArticle { [weak self] (resultArray, error) in
            guard (resultArray != nil) else {
                return
            }
            self?.dataArray = resultArray
            self?.headerRefresh()
            
        }
    }
}

typealias HynNewestDelegate = HynNewestViewController
// MARK: - UITableViewDelegate,UITableViewDataSource
extension HynNewestDelegate {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (dataArray != nil) else {
            return 0
        }
        return (dataArray?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HynReCommondArticleCell = tableView.dequeueReusableCell(withIdentifier: HynReCommondArticleCell.className(), for: indexPath) as! HynReCommondArticleCell
        guard dataArray != nil else {
            return cell
        }
        cell.reCommondArticleModel = self.dataArray?[indexPath.row]
        cell.likeDidClick = { [weak self] (is_liked,like_num) in
            self?.dataArray?[indexPath.row].is_liked = is_liked
            self?.dataArray?[indexPath.row].like_num = like_num
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard dataArray != nil else {
            return 126 + 30 + 5 + 140 + dataArray![indexPath.row].contentHeight!
        }
        let height = dataArray![indexPath.row].coverPic?.picSize?.height
        
        return height! + 30 + 5 + 100 + dataArray![indexPath.row].contentHeight!
        
    }
}

/// 当前类的工厂方法
extension HynNewestViewController {
    static func getNewestVC() -> HynNewestViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: HynNewestViewController.className()) as! HynNewestViewController
    }
}

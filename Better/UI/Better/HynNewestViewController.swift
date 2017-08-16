//
//  HynNewestViewController.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/19.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import MJRefresh

class HynNewestViewController: UITableViewController {
    
    var dataArray:[HynReCommondArticleModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        requstData()
        addRefresh()
    }
    
    func setUpTableView() {
        
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: HynHotBannerCell.className(), bundle: nil), forCellReuseIdentifier: HynHotBannerCell.className())
        tableView.register(UINib.init(nibName: HynReCommondArticleCell.className(), bundle: nil), forCellReuseIdentifier: HynReCommondArticleCell.className())
        
    }
    
}

/// 下拉刷新
extension HynNewestViewController {

    func addRefresh() {
        
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.requstData()
        })
        
    }
    
}

/// 数据请求
extension HynNewestViewController {
    
    func requstData() {
        
        HynReCommondArticleModel.getNewestArticle { [weak self] (resultArray, error) in
            guard (resultArray != nil) else {
                return
            }
            self?.dataArray = resultArray!
            self?.tableView.reloadData()
            self?.tableView.mj_header.endRefreshing()
            
        }
    }
}

typealias HynNewestDelegate = HynNewestViewController
// MARK: - UITableViewDelegate,UITableViewDataSource
extension HynNewestDelegate {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HynReCommondArticleCell = tableView.dequeueReusableCell(withIdentifier: HynReCommondArticleCell.className(), for: indexPath) as! HynReCommondArticleCell
        cell.reCommondArticleModel = self.dataArray[indexPath.row]
        cell.likeDidClick = { [weak self] (is_liked,like_num) in
            self?.dataArray[indexPath.row].is_liked = is_liked
            self?.dataArray[indexPath.row].like_num = like_num
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        guard dataArray.count != nil else {
//            return 126 + 30 + 5 + 140 + dataArray[indexPath.row].contentHeight!
//        }
        let height = dataArray[indexPath.row].coverPic.picSize.height
        
        return height + 30 + 5 + 100 + dataArray[indexPath.row].contentHeight
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let topicVC = HynTopicViewController.topicVC()
        topicVC.articleId = dataArray[indexPath.row].id
        self.navigationController?.pushViewController(topicVC, animated: true)
        
    }
}

/// 当前类的工厂方法
extension HynNewestViewController {
    
    static func getNewestVC() -> HynNewestViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: HynNewestViewController.className()) as! HynNewestViewController
    }
    
}

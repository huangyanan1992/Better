//
//  HynBetterViewController.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/14.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit
import Kingfisher
import DGElasticPullToRefresh

class HynReCommondViewController: UITableViewController {
    
    var dataArray:[HynReCommondArticleModel]?
    var currentPage:Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        requstData()
        addRefresh()
    }
    
    func setUpTableView() {
        
//        tableView.allowsSelection = false
        tableView.register(UINib.init(nibName: HynHotBannerCell.className(), bundle: nil), forCellReuseIdentifier: HynHotBannerCell.className())
        tableView.register(UINib.init(nibName: HynReCommondArticleCell.className(), bundle: nil), forCellReuseIdentifier: HynReCommondArticleCell.className())
        
    }
    
    deinit {
        print("\(self) deinit")
    }
    
}

extension HynReCommondViewController {
    
    func addRefresh() {
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 254/255.0, green: 196/255.0, blue: 62/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ 
            self.requstData()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(tableView.backgroundColor!)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        /**tableView.addRefreshHeader { [weak self] () in
            self?.currentPage = 1
            self?.requstData()
        }
        
        tableView.hyn_addRefreshFooter { [weak self] () in
            self?.currentPage = (self?.currentPage)! + 1
            self?.requstData()
        }
         */

    }
    
    @objc fileprivate func headerRefresh() {
        
        //self.tableView.hyn_headerEndRefreshing()
        self.tableView.dg_stopLoading()
        self.tableView.reloadData()
    }
    
    @objc fileprivate func footerRefresh() {
        
        //self.tableView.hyn_footerEndRefreshing()
        self.tableView.reloadData()
        
    }
    
}

typealias RecommondRequestData = HynReCommondViewController
// MARK: - 请求数据
extension RecommondRequestData {
    
    func requstData() {
        
        HynReCommondArticleModel.getReCommendArticleMain(currentPage: currentPage) { [weak self](resultArray, error) in
            guard (resultArray != nil) else {
                return
            }
//            if self?.currentPage == 1 {
                //下拉刷新
                self?.dataArray = resultArray
                self?.headerRefresh()
//            }
            /**else {
                //上拉加载更多
                for recommondArticleModel in resultArray! {
                    self?.dataArray?.append(recommondArticleModel)
                }
                
                self?.footerRefresh()
                
                if resultArray?.count == 0  {
                    self?.tableView.hyn_refreshDataLoadOver()
                }
            }*/
        }
    }
}

// MARK: - 获取当前controller
extension HynReCommondViewController {
    
    static func getReCommondVC() -> HynReCommondViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: HynReCommondViewController.className()) as! HynReCommondViewController
    }
    
}

typealias HynBetterDelegate = HynReCommondViewController
// MARK: - UITableViewDelegate,UITableViewDataSource
extension HynBetterDelegate {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (dataArray != nil) else {
            return 1
        }
        return (dataArray?.count)! + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell:HynHotBannerCell = tableView.dequeueReusableCell(withIdentifier: HynHotBannerCell.className(), for: indexPath) as! HynHotBannerCell
            cell.imageClicked = { [weak self] (url) in
                let webViewController = HynWebViewController.getWebVC()
                self?.navigationController?.pushViewController(webViewController, animated: true)
                webViewController.url = url
                
            }
            return cell
        }
        else {
            let cell:HynReCommondArticleCell = tableView.dequeueReusableCell(withIdentifier: HynReCommondArticleCell.className(), for: indexPath) as! HynReCommondArticleCell
            guard dataArray != nil else {
                return cell
            }
            cell.reCommondArticleModel = self.dataArray?[indexPath.row-1]
            cell.likeDidClick = { [weak self] (is_liked,like_num) in
                self?.dataArray?[indexPath.row-1].is_liked = is_liked
                self?.dataArray?[indexPath.row-1].like_num = like_num
            }
            return cell
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 205
        }
        guard dataArray != nil else {
            return 126 + 30 + 5 + 140 + dataArray![indexPath.row-1].contentHeight!
        }
        let height = dataArray![indexPath.row-1].coverPic?.picSize?.height
        
        return height! + 30 + 5 + 100 + dataArray![indexPath.row-1].contentHeight!
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            let topicVC = HynTopicViewController.topicVC()
            topicVC.articleId = dataArray?[indexPath.row-1].id
            self.navigationController?.pushViewController(topicVC, animated: true)
        }
    }
}

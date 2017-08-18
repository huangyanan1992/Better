//
//  HynTopicViewController.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/26.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit
import MJRefresh

class HynTopicViewController: UIViewController {
    
    var emotionKeyBoard:HynEmotionKeyBoard?
    
    var tableView:UITableView = UITableView.init()
    
    var pageSize:Int = 15
    
    
    var articleId:Int? {
        didSet {
            loadData()
        }
    }
    var topicModel:HynTopicModel?
    var commondArray:[HynCommondModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubViews()
    }
    
    deinit {
        print(HynTopicViewController.self)
    }
}

typealias TopicRefresh = HynTopicViewController
extension TopicRefresh {
    
    func addRefresh() {
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            
            self.topicModel = nil
            self.tableView.mj_footer.resetNoMoreData()
            self.pageSize = 15
            self.loadArticle()
            
        })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            
            self.loadCommond()
            self.pageSize = self.pageSize + 15
            
        })
        
    }
    
}

typealias TopicSubViews = HynTopicViewController
extension TopicSubViews {
    
    fileprivate func setUpSubViews() {
        
        setUpBackBtn()
        setUpTableView()
        registerCell()
        bottomView()
        addRefresh()
        
    }
    
    private func bottomView() {
        
        emotionKeyBoard = HynEmotionKeyBoard.init(frame: CGRect(x: 0, y: .screenHeight()-emotionTextFieldHeight-64, width: .screenWidth(), height: itemHeight*3+emotionKeyBoardBottomHeight+emotionTextFieldHeight))
        view.addSubview(emotionKeyBoard!)
    }
    
    private func setUpTableView() {
        
        tableView.frame = CGRect.init(x: 0, y: 0, width: .screenWidth(), height: .screenHeight()-64)
        tableView.backgroundColor = HynThemeManager.shared.backgroundColor
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(keyBoardHiden))
        tap.numberOfTapsRequired = 1
        tableView.addGestureRecognizer(tap)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    private func registerCell() {
        
        tableView.register(UINib.init(nibName: HynArticleCell.className(), bundle: nil), forCellReuseIdentifier: HynArticleCell.className())
        tableView.register(UINib.init(nibName: HynImageCell.className(), bundle: nil), forCellReuseIdentifier: HynImageCell.className())
        tableView.register(UINib.init(nibName: HynLikeMembersCell.className(), bundle: nil), forCellReuseIdentifier: HynLikeMembersCell.className())
        tableView.register(UINib.init(nibName: HynCommonCell.className(), bundle: nil), forCellReuseIdentifier: HynCommonCell.className())
    }
    
    
}

typealias TopicInit = HynTopicViewController
extension TopicInit {
    
    static func topicVC() -> HynTopicViewController {
        
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: HynTopicViewController.className()) as! HynTopicViewController
        
    }
    
}

typealias TopicLoadData = HynTopicViewController
extension TopicLoadData {
    
    func loadData() {
        
        loadArticle()
        loadCommond()
        
    }
    
    func loadArticle() {
        
        HynTopicModel.getArticleById(articleId: articleId!) { [weak self] (topicModel, error) in
            
            guard (topicModel != nil) else {
                return
            }
            self?.topicModel = topicModel
            self?.tableView.reloadData()
            self?.tableView.mj_header.endRefreshing()
            
        }
    }
    
    func loadCommond() {
        HynCommondModel.getCommond(articleId: articleId!, pageSize: pageSize) { [weak self] (commondArray, error) in
            
            guard (commondArray != nil) else {
                return
            }
            guard self?.commondArray.count != commondArray?.count else {
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            self?.commondArray = commondArray!
            self?.tableView.reloadData()
            self?.tableView.mj_footer.endRefreshing()
            
        }
    }
    
}

typealias TopicDelegate = HynTopicViewController
extension TopicDelegate:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            guard (topicModel?.article.picsModel != nil) else {
                return 0
            }
            return 2 + (topicModel?.article.picsModel.count)!
        }
        else {
            return commondArray.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                let cell:HynArticleCell = tableView.dequeueReusableCell(withIdentifier: HynArticleCell.className(), for: indexPath) as! HynArticleCell
                cell.article = topicModel?.article
                return cell
                
            }
            else if indexPath.row == (topicModel?.article.picsModel.count)! + 1 {
                
                let cell:HynLikeMembersCell = tableView.dequeueReusableCell(withIdentifier: HynLikeMembersCell.className(), for: indexPath) as! HynLikeMembersCell
                cell.likes = topicModel?.likes
                cell.article = topicModel?.article
                return cell
                
            }
            else {
                
                let cell:HynImageCell = tableView.dequeueReusableCell(withIdentifier: HynImageCell.className(), for: indexPath) as! HynImageCell
                cell.pic = topicModel?.article.picsModel[indexPath.row-1]
                return cell
                
            }
        }
        else {
            
            let cell:HynCommonCell = tableView.dequeueReusableCell(withIdentifier: HynCommonCell.className(), for: indexPath) as! HynCommonCell
            cell.commondModel = commondArray[indexPath.row]
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            
            let commondNumView:HynCommondNumView = HynCommondNumView.initWithNib() as! HynCommondNumView
            commondNumView.commond_num = topicModel?.article.comment_num
            return commondNumView
            
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 {
            return 44
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                return CGFloat(83 + (topicModel?.article.contentHeight)!+10)
            }
            else if indexPath.row <= (topicModel?.article.picsModel.count)! {
                return (topicModel?.article.picsModel[indexPath.row-1].picSize.height)! + 2
            }
            else {
                return 44
            }
        }
        else {
            return 83 + commondArray[indexPath.row].contentHeight+5
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        emotionKeyBoard?.keyBoardAllHide()
    }
    
}

extension HynTopicViewController {
    func keyBoardHiden() {
        emotionKeyBoard?.keyBoardAllHide()
    }
}


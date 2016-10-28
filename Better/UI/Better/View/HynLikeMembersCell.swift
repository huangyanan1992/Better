//
//  HynLikeMembersCell.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/26.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class HynLikeMembersCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commondLabel: UILabel!
    @IBOutlet weak var commondImageView: UIImageView!
    
    var likes:[HynUserModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var article:HynArticle? {
        didSet {
            guard (article != nil) else {
                return
            }
            if article?.isLiked == 0 {
                isLike = false
            }
            else {
                isLike = true
            }
        }
    }
    
    
    var isLike:Bool = false {
        didSet {
            if isLike {
                likeBtn.setImage(UIImage.init(named: "真赞-"), for: .normal)
            }
            else {
                likeBtn.setImage(UIImage.init(named: "真赞"), for: .normal)
            }
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 20, height: 20)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib.init(nibName: HynLikeMemberCollectionCell.className(), bundle: nil), forCellWithReuseIdentifier: HynLikeMemberCollectionCell.className())
        collectionView.register(UINib.init(nibName: HynLikeNumCollectionCell.className(), bundle: nil), forCellWithReuseIdentifier: HynLikeNumCollectionCell.className())
        
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        
    }
    
}

typealias LikeMembersDelegate = HynLikeMembersCell
extension LikeMembersDelegate:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard (likes?.count)! < 3 else {
            return 4
        }
        return (likes?.count)!+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == collectionView.numberOfItems(inSection: 0)-1 {
            let cell:HynLikeNumCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: HynLikeNumCollectionCell.className(), for: indexPath) as! HynLikeNumCollectionCell
//            cell.layer.cornerRadius = cell.bounds.width/2.0
//            cell.clipsToBounds = true
            cell.likeNum = article?.like_num
            return cell
        }
        else {
            let cell:HynLikeMemberCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: HynLikeMemberCollectionCell.className(), for: indexPath) as! HynLikeMemberCollectionCell
//            cell.layer.cornerRadius = cell.bounds.width/2.0
//            cell.clipsToBounds = true
            cell.userModel = likes?[indexPath.row]
            return cell
        }
        
        
    }
}

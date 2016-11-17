//
//  HynPhotoBrowserController.swift
//  Better
//
//  Created by Huang Yanan on 2016/11/16.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

/// 图片浏览
import UIKit

class HynPhotoBrowser:UIView {
    
    @IBOutlet weak var numOfImages: UILabel!
    
    var dataArray:[UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    /// 当前选中的照片索引
    var currentIndexPath:IndexPath = IndexPath.init(row: 0, section: 0) {
        didSet {
            collectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
            numOfImages.text = String(format: "%d/%d", currentIndexPath.row+1,dataArray.count)
        }
    }
    
    fileprivate lazy var collectionView:UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: .screenWidth(), height: .screenHeight()-110)
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 60, width: .screenWidth(), height: .screenHeight()-110), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .black
        collectionView.register(UINib.init(nibName: HynPhotoBrowserCell.className(), bundle: nil), forCellWithReuseIdentifier: HynPhotoBrowserCell.className())
        collectionView.isPagingEnabled = true
        return collectionView
        
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        frame = CGRect(x: 0, y: -.screenHeight(), width: .screenWidth(), height: .screenHeight())
        backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
    }
    
    func show() {
        self.viewController()?.navigationController?.isNavigationBarHidden = true
        self.frame = CGRect(x: 0, y: 0, width: .screenWidth(), height: .screenHeight())
    }
    
    func dismiss() {
        self.viewController()?.navigationController?.isNavigationBarHidden = false
        self.frame = CGRect(x: 0, y: -.screenHeight(), width: .screenWidth(), height: .screenHeight())
    }

    @IBAction func close(_ sender: UIButton) {
        dismiss()
    }

}

private typealias HynPhotoBrowserDelegate = HynPhotoBrowser
extension HynPhotoBrowserDelegate:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:HynPhotoBrowserCell = collectionView.dequeueReusableCell(withReuseIdentifier: HynPhotoBrowserCell.className(), for: indexPath) as! HynPhotoBrowserCell
        
        cell.imgView.image = dataArray[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x/(.screenWidth())+1)
        print(page)
        numOfImages.text = String(format: "%d/%d", page,dataArray.count)
    }
}

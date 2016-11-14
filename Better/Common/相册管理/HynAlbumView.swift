//
//  HynAlbumView.swift
//  Better
//
//  Created by Huang Yanan on 2016/11/8.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit
import Photos

class HynAlbumView: UIView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var maskingView: UIView!
    
    //相簿列表项集合
    fileprivate var albumItems:[HynAlbumItem] = []
    fileprivate var currentItem:HynAlbumItem? {
        didSet {
            guard (selectedAlbumClosure != nil) else {
                return
            }
            selectedAlbumClosure!(currentItem!)
        }
    }
    
    var selectedAlbumClosure:((_ albumItem:HynAlbumItem)->())?
    var selectedRow:Int = 0
    
    var tapDidClick:(()->())?
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        dismiss()
        guard (tapDidClick != nil) else {
            return
        }
        tapDidClick!()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        frame = CGRect(x: 0, y: 0, width: .screenWidth(), height: .screenHeight())
        self.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: HynAlbumCell.className(), bundle: nil), forCellReuseIdentifier: HynAlbumCell.className())
    }

}

extension HynAlbumView {
    
    func show() {
        
        self.isHidden = false
        UIView.animate(withDuration: 0.25) { 
            self.tableView.frame = CGRect(x: 0, y: 0, width: .screenWidth(), height: self.tableViewHeight.constant)
            self.maskingView.alpha = 0.6
        }
        
    }
    
    func dismiss() {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.tableView.frame = CGRect(x: 0, y: -self.tableViewHeight.constant, width: .screenWidth(), height: self.tableViewHeight.constant)
            self.maskingView.alpha = 0
            
        }) { (isFinish) in
            
            if isFinish {
                self.isHidden = true
            }
        }
    }
}

extension HynAlbumView {
    
    func loadData() {
        
        // 列出所有系统的智能相册
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        convertCollection(assetCollections: smartAlbums)
        
        //列出所有用户创建的相册
        let userCollections = PHAssetCollection.fetchTopLevelUserCollections(with: nil)
        convertCollection(assetCollections: userCollections as! PHFetchResult<PHAssetCollection>)
        
        //相册按包含的照片数量排序（降序）
        albumItems.sort {
            $0.fetchResult.count > $1.fetchResult.count
        }
        
        if albumItems.count >= 4 {
            tableViewHeight.constant = 4*80
        }
        else {
            tableViewHeight.constant = CGFloat(albumItems.count)*80
        }
        
        tableView.reloadData()
        
        for albumItem in albumItems {
            if albumItem.title == "相机胶卷" {
                currentItem = albumItem
            }
        }
        
    }
    
    private func convertCollection(assetCollections:PHFetchResult<PHAssetCollection>) {
        
        for i in 0..<assetCollections.count{
            //获取出但前相簿内的图片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            let assetCollection = assetCollections[i]
            let assetsFetchResult = PHAsset.fetchAssets(in: assetCollection, options: resultsOptions)
            //没有图片的空相簿不显示
            let albumItem = HynAlbumItem(title: assetCollection.localizedTitle, fetchResult: assetsFetchResult)
            if assetsFetchResult.count > 0 {
                albumItems.append(albumItem)
            }
            
        }
        
    }
}

extension HynAlbumView:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(albumItems.count)
        return albumItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HynAlbumCell = tableView.dequeueReusableCell(withIdentifier: HynAlbumCell.className(), for: indexPath) as! HynAlbumCell
        cell.albumItem = albumItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentItem = albumItems[indexPath.row]
        dismiss()
    }
}

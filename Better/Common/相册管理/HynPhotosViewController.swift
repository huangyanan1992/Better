//
//  HynPhotosViewController.swift
//  Better
//
//  Created by Huang Yanan on 2016/11/7.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit
import Photos

class HynPhotosViewController: UIViewController {
    
    ///最大限制默认是9张照片
    var limitMaxCout:Int = 9
    
    /// 当前选中相册的所有照片
    var currentAlbum:[PHAsset] = []
    
    /// 选中的照片
    var imagesDidSelected:((_ selectedAsset:[PHAsset])->())?
    
    ///已选中的相册和indexPath.row和图片
    var selectedImages:[PHAsset] = [] {
        didSet {
            if selectedImages.count == 0 {
                nextButton.isHidden = true
            }
            else {
                nextButton.isHidden = false
                nextButton.setTitle(String(format: "下一步(%d)", selectedImages.count), for: .normal)
            }
        }
    }
    
    typealias cameraImageClosure = (_ image:UIImage)->()
    fileprivate var cameraImage:cameraImageClosure?
    
    /// 相机照片
    ///
    /// - Parameter image: 拍照获得的照片
    func requestCameraImage(image:@escaping cameraImageClosure) {
        cameraImage = image
    }
    
    ///标题
    lazy var titleButton:UIButton = {
        let button = UIButton.init(frame: CGRect(x: (.screenWidth()-100)/2.0, y: 0, width: 100, height: 30))
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setImage(UIImage.init(named: "navigationbar_arrow_up"), for: .normal)
        button.isSelected = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    ///下一步
    lazy var nextButton:UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(HynThemeManager.shared.mainColor, for: .normal)
        return button
    }()
    
    fileprivate lazy var collectionView:UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: .screenWidth()/3.0, height: .screenWidth()/3.0)
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: .screenWidth(), height: .screenHeight()-64), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = HynThemeManager.shared.backgroundColor
        collectionView.register(UINib.init(nibName: HynImagePickerCell.className(), bundle: nil), forCellWithReuseIdentifier: HynImagePickerCell.className())
        collectionView.register(UINib.init(nibName: HynCameraCell.className(), bundle: nil), forCellWithReuseIdentifier: HynCameraCell.className())
        return collectionView
        
    }()
    
    fileprivate lazy var albumView:HynAlbumView = {
        let albumView = HynAlbumView.initWithNib() as! HynAlbumView
        return albumView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackBtn()
        setUpSubViews()
        
    }
    
    deinit {
        print("deinit")
    }
}

extension HynPhotosViewController {
    
    fileprivate func setUpSubViews() {
        
        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)
        
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        let nextItem = UIBarButtonItem.init(customView: nextButton)
        navigationItem.rightBarButtonItems = [nextItem]
        
        navigationItem.titleView = titleButton
        titleButton.addTarget(self, action: #selector(titleAction), for: .touchUpInside)
        
        
        view.addSubview(albumView)
        albumView.selectedAlbumClosure = { [weak self] (albumItem) in
            /**选择相册
             * 1.如果选中的是当前相册，不改变图片
             * 2.如果不是当前相册，替换当前照片为选中相册中的图片
             * 3.修改标题为当前选中的相册
             */
            self?.titleAction()
            guard self?.titleButton.title(for: .normal) != albumItem.title else {
                return
            }
            self?.currentAlbum.removeAll()
            albumItem.fetchResult.enumerateObjects({ (asset, index, stop) in
                self?.currentAlbum.append(asset)
            })
            self?.titleButton.setTitle(albumItem.title, for: .normal)
            self?.collectionView.reloadData()
        }
        ///收起相册页，标题页跟着收起
        albumView.tapDidClick = { [weak self] in
            self?.titleAction()
        }
        ///加载相册数据
        albumView.loadData()
    
    }
    
    ///点击标题
    @objc private func titleAction() {
        
        titleButton.isSelected = !titleButton.isSelected
        if titleButton.isSelected {
            titleButton.setImage(UIImage.init(named: "navigationbar_arrow_up"), for: .normal)
            albumView.show()
        }
        else {
            titleButton.setImage(UIImage.init(named: "navigationbar_arrow_down"), for: .normal)
            albumView.dismiss()
        }
    }
    
    @objc private func nextAction() {
        
        guard (imagesDidSelected != nil) else {
            return
        }
        imagesDidSelected!(self.selectedImages.flatMap{$0})
        dismiss(animated: true, completion: nil)
    }
    
}

extension HynPhotosViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentAlbum.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell:HynCameraCell = collectionView.dequeueReusableCell(withReuseIdentifier: HynCameraCell.className(), for: indexPath) as! HynCameraCell
            return cell
            
        }
        else {
            let cell:HynImagePickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: HynImagePickerCell.className(), for: indexPath) as! HynImagePickerCell
            cell.assert = currentAlbum[indexPath.row-1]
            cell.imgIsSelected = false
            ///设置选中的顺序
            for i in 0..<selectedImages.count {
                ///当前照片是否是选中的，是显示选中效果，和选中的次序
                if selectedImages[i].localIdentifier == currentAlbum[indexPath.row-1].localIdentifier {
                    cell.imgIsSelected = true
                    cell.count = i
                }
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row != 0 {
            
            let cell:HynImagePickerCell = collectionView.cellForItem(at: indexPath) as! HynImagePickerCell
            
            ///改变当前图片的选中效果
            cell.imgIsSelected = !cell.imgIsSelected
            /**
             * 1.如果选中，添加选中的图片到selectedImages中
             * 2.如果没选中，从selectedImages中移除该图片
             */
            if cell.imgIsSelected {
                ///确保已选照片小于最大限制
                guard selectedImages.count < limitMaxCout else {
                    cell.imgIsSelected = !cell.imgIsSelected
                    return
                }
                selectedImages.append(self.currentAlbum[indexPath.row-1])
            }
            else {
                let index = Int(cell.selectedNum.text!)
                selectedImages.remove(at: index!-1)
            }
            
            self.collectionView.reloadData()
            
        }
        else {
            
            HynCameraManager.requestCameraAuthorizationStatus(complite: {  [weak self] in
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    return
                }
                
                let imagePickerViewController = HynImagePickerController.init()
                
                imagePickerViewController.requstImage(finish: { (image) in
                    guard (self?.cameraImage != nil) else {
                        return
                    }
                    self?.cameraImage!(image)
                    
                    DispatchQueue.main.async {
                        self?.dismiss(animated: false, completion: nil)
                    }
                    
                })
                self?.present(imagePickerViewController, animated: true, completion: nil)
                
            })
            
        }
    }
}



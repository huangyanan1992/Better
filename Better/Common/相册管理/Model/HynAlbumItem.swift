//
//  HynAlbumItem.swift
//  Better
//
//  Created by Huang Yanan on 2016/11/8.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit
import Photos

class HynAlbumItem {
    //相簿名称
    var title:String?
    //相簿内的资源
    var fetchResult:PHFetchResult<PHAsset>
    
    init(title:String?,fetchResult:PHFetchResult<PHAsset>){
        self.title = title
        self.fetchResult = fetchResult
    }
}

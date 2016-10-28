//
//  HynRefreshEnum.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/20.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import Foundation


/// 下拉状态
///
/// - normal:        无
/// - waitRefresh: 等待刷新
/// - refreshing:  正在刷新
enum HynRefreshHeaderStatus {
    case normal
    case waitRefresh
    case refreshing
}


/// 上拉状态
///
/// - normal:        无
/// - waitRefresh: 等待刷新
/// - refreshing:  正在刷新
/// - over:        刷新结束
enum HynRefreshFooterStatus {
    case normal
    case waitRefresh
    case refreshing
    case over
}


/// 刷新对象
///
/// - none:   无
/// - header: 下拉刷新
/// - footer: 上拉刷新
enum HynRefreshObject {
    case none
    case header
    case footer
}

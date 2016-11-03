//
//  HynRefresh.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/20.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

typealias HynHeaderClosure = ()->Void
typealias HynFooterClosure = ()->Void
private var headerRefreshClosure:HynHeaderClosure?
private var footerRefreshClosure:HynFooterClosure?
private var header:HynRefreshHeader!
private var footer:HynRefreshFooter!

private var refreshObj = HynRefreshObject.header
private var lastRefreshObj = HynRefreshObject.header

private var footerView:UIView?

private let contentOffsetKeyPath = "contentOffset"
//private var obserVerIsRemove:Bool?
//private var currentClass:String?

private func address<T: AnyObject>(o: T) -> String {
    return String.init(format: "%018p", unsafeBitCast(o, to: Int.self))
}

// MARK: - header相关
extension UIScrollView {
    
    private struct CurrentClass {
        static var xoCurrentClass: UInt = 0
        static var xoObserVerIsRemove: UInt = 1
    }
    
    var currentClassAddress:String? {
        get {
            return objc_getAssociatedObject(self, &CurrentClass.xoCurrentClass) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &CurrentClass.xoCurrentClass, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var obserVerIsRemove:Bool? {
        get {
            return objc_getAssociatedObject(self, &CurrentClass.xoObserVerIsRemove) as? Bool
        }
        set(newValue) {
            objc_setAssociatedObject(self, &CurrentClass.xoObserVerIsRemove, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    /// 添加下拉刷新
    func hyn_addRefreshHeader(headerRefresh:@escaping HynHeaderClosure) {
        
        obserVerIsRemove = false
        weak var weakSelf = self
        guard (weakSelf != nil) else {
            return
        }
        currentClassAddress = address(o: weakSelf!)
        addObserver(self, forKeyPath: contentOffsetKeyPath, options: NSKeyValueObservingOptions.new, context: nil)
        header = HynRefreshHeader.initWithNib() as! HynRefreshHeader
        guard (header != nil) else {
            print("header 加载失败")
            return
        }
        header.center = HynRefreshHeaderCenter
        
        let headerView = UIView.init(frame: CGRect(x: HynRefreshHeaderX, y: HynRefreshHeaderY, width: UIScreen.main.bounds.width, height: HynRefreshHeaderHeight))
        headerView.backgroundColor = UIColor.clear
        headerView.addSubview(header)
        
        weakSelf?.addSubview(headerView)
        
        weakSelf!.panGestureRecognizer.addTarget(weakSelf!, action: #selector(UIScrollView.scrollViewDragging(_:)))
        headerRefreshClosure =  headerRefresh
        hyn_refresh()

    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        let selfAddress = self
        
        if currentClassAddress ==  address(o: selfAddress){
            if obserVerIsRemove == false {
                obserVerIsRemove = true
                removeObserver(self, forKeyPath: contentOffsetKeyPath, context: nil)
            }
            else {
                obserVerIsRemove = false
                addObserver(self, forKeyPath: contentOffsetKeyPath, options: NSKeyValueObservingOptions.new, context: nil)
            }
        }
    }
    
    func hyn_refresh() {
        headerRefreshClosure!()
    }
    
    /// header 刷新状态
    ///
    /// - returns: 是否正在刷新
    private func headerIsRefreshing() -> Bool {
        guard header != nil else{
            return false
        }
        
        return header!.refreshStatus == HynRefreshHeaderStatus.refreshing ? true: false
    }
    
    /// header 结束刷新
    func hyn_headerEndRefreshing() {
        
        weak var weakSelf = self
        guard header != nil else{
            return
        }
        if !headerIsRefreshing() {
            return
        }
        if lastRefreshObj == HynRefreshObject.header {
            weakSelf!.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.25) {
            
            header!.refreshStatus = .normal
            lastRefreshObj = .header
            self.hyn_footerRefreshReset()
            
        }
    }
}


// MARK: - footer相关
extension UIScrollView {
    
    func hyn_addRefreshFooter(footerRefresh:@escaping HynFooterClosure) {
        
        weak var weakSelf = self
        footer = HynRefreshFooter.initWithNib() as? HynRefreshFooter
        guard footer != nil else{
            print("Footer加载失败")
            return
        }
        
        footerView = {
            let y = (weakSelf?.contentSize.height)!>UIScreen.main.bounds.height-64-44 ? weakSelf?.contentSize.height:UIScreen.main.bounds.height-64-44
            let view = UIView.init(frame: CGRect(x: HynRefreshFooterX, y: y!, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            view.backgroundColor = UIColor.clear
            view.addSubview(footer!)
            view.isHidden = true
            addSubview(view)
            return view
        }()
    
        weakSelf!.panGestureRecognizer.addTarget(weakSelf!, action: #selector(UIScrollView.scrollViewDragging(_:)))
        
        footerRefreshClosure = footerRefresh
    }
    
    /// footer 刷新状态
    ///
    /// - returns: 是否正在刷新
    private func footerIsRefreshing() -> Bool {
        guard footer != nil else{
            return false
        }
        
        return footer!.refreshStatus == .refreshing ? true: false
    }
    
    /// footer 结束刷新
    func hyn_footerEndRefreshing() {
        weak var weakSelf = self
        guard footer != nil else{
            return
        }
        if !footerIsRefreshing() {
            return
        }
        let size = weakSelf!.contentSize
        weakSelf!.contentSize = CGSize(width: size.width, height: size.height - HynRefreshFooterHeight)
        
        /** 
         1、数据没有充满屏幕，停在（0，0）
         2、数据已经填充满屏幕，停在
        */
        if size.height < weakSelf!.bounds.size.height {
            weakSelf!.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }else{
            var offSet = weakSelf!.contentSize.height-weakSelf!.bounds.size.height
            offSet = offSet>0 ? offSet:0
            weakSelf!.setContentOffset(CGPoint(x: 0, y: offSet), animated: true)
        }
        footer.refreshStatus = .normal
        footerView!.isHidden = true
        
        lastRefreshObj = .footer
    }
    
    /// 数据加载完毕状态
    func hyn_footerDataLoadOver() {
        weak var weakSelf = self
        guard footer != nil else{
            return
        }
        let size = weakSelf!.contentSize
        footerView!.isHidden = false
        footerView!.frame = CGRect(x: HynRefreshFooterX, y: size.height, width: UIScreen.main.bounds.size.width, height: HynRefreshFooterHeight)
        
        weakSelf!.contentSize = CGSize(width: size.width, height: size.height + HynRefreshFooterHeight)
        footer.refreshStatus = .over
    }
    
    /// 初始化状态
    fileprivate func hyn_footerRefreshReset() {
        guard footer != nil else{
            return
        }
        
        //重置contentOffSet放在footerView隐藏之后，否则，由于footerview的隐藏，contentsize会发生改变，contentOffset也会发生改变
        footerView!.isHidden = true
        footer.refreshStatus = .normal
        weak var weakSelf = self
        weakSelf!.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension UIScrollView {
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let offSet = self.contentOffset.y
        let scrollHeight = self.bounds.size.height
        let inset = self.contentInset
        var currentOffset = offSet + scrollHeight - inset.bottom
        let maximumOffset = self.contentSize.height
        
        //数据未充满屏幕
        if maximumOffset < scrollHeight {
            currentOffset = offSet + maximumOffset - inset.bottom
        }
        
        if offSet < 0 {
            //下拉刷新
            guard header != nil else{
                return
            }
            scrollHeader(offSet)
            refreshObj = HynRefreshObject.header
        }
        else if currentOffset - maximumOffset > 0 {
            // 上拉加载更多
            guard footer != nil else{
                return
            }
            guard footer!.refreshStatus != .over else {
                return
            }
            
            scrollFooter(currentOffset - maximumOffset)
            refreshObj = .footer
            
        }else{
            // 无刷新对象
            refreshObj = .none
        }
    }
    
    fileprivate func scrollHeader(_ offSet: CGFloat) {//参数为负数
        
        guard header != nil else{
            return
        }
        if header!.refreshStatus == .refreshing {
            return
        }
        else {
            if offSet < -HynRefreshHeaderHeight {
                header.refreshStatus = .waitRefresh
                //print("waitRefresh")
                //print(offSet)
            }
            else{
                header.refreshStatus = .normal
                //print("normal")
            }
        }
        
    }
    
    fileprivate func scrollFooter(_ offSet: CGFloat) {
        weak var weakSelf = self
        guard footer != nil else{
            return
        }
        guard footer!.refreshStatus != .refreshing else{
            return
        }
        
        footerView!.isHidden = false
        footerView!.frame = CGRect(x: HynRefreshFooterX, y: weakSelf!.contentSize.height, width: UIScreen.main.bounds.width, height: HynRefreshFooterHeight)
        
        if offSet > HynRefreshFooterHeight {
            footer.refreshStatus = .waitRefresh
        }
        else{
            footer.refreshStatus = .normal
        }
        
    }
    
    // 拖拽
    @objc fileprivate func scrollViewDragging(_ pan: UIPanGestureRecognizer){
        print(pan.translation(in: self))
        if pan.state == .ended {
            
            print(pan.translation(in: self))
            if refreshObj == .header {
                draggHeader()
                
            }else if refreshObj == .footer{
                draggFooter()
            }
        }
    }
    
    fileprivate func draggHeader(){
        weak var weakSelf = self
        guard header != nil else{
            return
        }
        if header!.refreshStatus == .waitRefresh {
            weakSelf!.setContentOffset(CGPoint(x: 0, y: -HynRefreshHeaderHeight), animated: true)
            header.refreshStatus = .refreshing
            if headerRefreshClosure != nil {
                headerRefreshClosure!()
            }
        }else if header!.refreshStatus == .refreshing{
            weakSelf!.setContentOffset(CGPoint(x: 0, y: -HynRefreshHeaderHeight), animated: true)
            
        }
    }
    
    fileprivate func draggFooter() {
        weak var weakSelf = self
        guard footer != nil else{
            return
        }
        if footer!.refreshStatus == .waitRefresh {
            // 设置scroll的contentsize 以及滑动offset
            let size = weakSelf!.contentSize
            weakSelf!.contentSize = CGSize(width: size.width, height: size.height + HynRefreshFooterHeight)
            /**
             1、数据没有充满屏幕,停在（0，0）
             2、数据已经填充满屏幕,停在刷新前最后一屏的位置
             */
            if size.height < weakSelf!.bounds.size.height {
                weakSelf!.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            else{
                let offSet = weakSelf!.contentSize.height-weakSelf!.bounds.size.height
                weakSelf!.setContentOffset(CGPoint(x: 0, y: offSet), animated: true)
            }
            // 切换状态
            footer.refreshStatus = .refreshing
            if footerRefreshClosure != nil {
                footerRefreshClosure!()
            }
        }
    }
}

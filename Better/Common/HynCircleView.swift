//
//  HynCircleView.swift
//  HGADView
//
//  Created by Huang Yanan on 2016/10/17.
//  Copyright © 2016年 nero. All rights reserved.
//

import UIKit
import Kingfisher

private let kCircleViewHeight = 150

class HynCircleView<ImageType>: UIView,UIScrollViewDelegate {
    public typealias DidClick = (Int) -> Void
    public var imageDidClick:DidClick?
    
    public var images = [ImageType]() {
        didSet {
            pageControl.numberOfPages = images.count
            scrollView.contentSize = CGSize(width: self.frame.width * CGFloat(images.count), height: self.frame.height)
            
            reloadData()
            removeTimer()
            if images.count > 1 { addTimer() }
        }
    }
    
    //   MARK: - 移除定时器
    public func removeTimer() {
        timer?.invalidate()
        timer = nil
        
    }
    //    MARK: - 添加定时器
    public func addTimer() {
        guard  images.count > 0 else  {return;}
        if (timer != nil) {
            return
        }
        timer = Timer(timeInterval: 2.5, target: self, selector: #selector(HynCircleView.timerScrollImage), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)
        RunLoop.current.run(mode: RunLoopMode.UITrackingRunLoopMode, before: Date())
        
    }
    
    
    
    private var currentImageArray = [ImageType]()
    private var currentPage = 0
    
    private var timer:Timer?
    
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        scrollView.contentOffset = CGPoint(x: self.frame.width, y: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var pageControl:UIPageControl = {
        let pageWidth = self.frame.width * 0.25
        let pageHeight:CGFloat = 20.0
        let pageX = self.frame.width - pageWidth - 10.0
        let pageY = self.frame.height -  30.0
        let pageControl = UIPageControl(frame: CGRect(x: pageX, y: pageY, width: pageWidth, height: pageHeight))
        pageControl.isUserInteractionEnabled = false
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.gray
        return pageControl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        addSubview(pageControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        scrollView.delegate = nil
        removeTimer()
    }
    
    private func reloadData() {
        
        //设置页数
        pageControl.currentPage = currentPage
        //根据当前页取出图片
        getDisplayImagesWithCurpage()
        //从scrollView上移除所有的subview
        scrollView.subviews.forEach({$0.removeFromSuperview()})
        
        for i in 0..<3 {
            let frame = CGRect(x: self.frame.width * CGFloat(i), y: 0, width: self.frame.width, height: self.frame.height)
            let imageView = UIImageView(frame: frame)
            imageView.isUserInteractionEnabled = true
            imageView.clipsToBounds = true
            scrollView.addSubview(imageView)
            imageView.kf.setImage(with: URL(string:currentImageArray[i] as! String))
            let tap = UITapGestureRecognizer(target: self, action: #selector(HynCircleView.tapImage))
            imageView.addGestureRecognizer(tap)
        }
        
        
        
        
    }
    private func  getDisplayImagesWithCurpage() {
        //取出开头和末尾图片在图片数组里的下标
        var front = currentPage - 1
        var last = currentPage + 1
        //如果当前图片下标是0，则开头图片设置为图片数组的最后一个元素
        if currentPage == 0 {
            front = images.count - 1
        }
        //如果当前图片下标是图片数组最后一个元素，则设置末尾图片为图片数组的第一个元素
        if currentPage == images.count - 1 {
            last = 0
        }
        //如果当前图片数组不为空，则移除所有元素
        if currentImageArray.count > 0 {
            currentImageArray = [ImageType]()
        }
        //当前图片数组添加图片
        currentImageArray.append(images[front])
        currentImageArray.append(images[currentPage])
        currentImageArray.append(images[last])
        
    }
    
    @objc private func tapImage() {
        imageDidClick?(currentPage)
        
    }
    
    @objc private func timerScrollImage() {
        reloadData()
        scrollView.setContentOffset(CGPoint(x: frame.width * 2.0 , y: 0) , animated: true)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //如果scrollView当前偏移位置x大于等于两倍scrollView宽度
        if scrollView.contentOffset.x >= frame.width * 2.0 {
            //当前图片位置+1
            currentPage += 1
            //如果当前图片位置超过数组边界，则设置为0
            if currentPage == images.count {
                currentPage = 0
            }
            reloadData()
            //设置scrollView偏移位置
            scrollView.contentOffset = CGPoint(x: frame.width, y: 0)
        }else if scrollView.contentOffset.x <= 0.0{
            currentPage -= 1
            if currentPage == -1 {
                currentPage = images.count - 1
            }
            reloadData()
            //设置scrollView偏移位置
            scrollView.contentOffset = CGPoint(x: frame.width, y: 0)
        }
        
    }
    // 停止滚动的时候回调
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint(x: frame.width, y: 0), animated: true)
    }
    // 开始拖拽的时候调用
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 停止定时器(一旦定时器停止了,就不能再使用)
        removeTimer()
    }
    // 停止拖拽的时候调用
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    

}

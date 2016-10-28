//
//  HynHomeViewController.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/19.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit

class HynHomeViewController: UIViewController {
    
    var reCommondViewController:HynReCommondViewController!
    var newestViewController:HynNewestViewController!
    
    var viewControllersArray:[UIViewController] = Array()
    
    
    @IBOutlet weak var segMentedControl: UISegmentedControl!
    
    var pageViewController:UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpSubViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (navigationController?.viewControllers.count)! > 1 {
            (tabBarController as! RAMAnimatedTabBarController).animationTabBarHidden(true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (navigationController?.viewControllers.count)! == 1 {
            (tabBarController as! RAMAnimatedTabBarController).animationTabBarHidden(false)
        }
    }
}

typealias HynHomeSubView = HynHomeViewController
extension HynHomeSubView {
    func setUpSubViews() {
        //获取到嵌入的UIPageViewController
        pageViewController = self.childViewControllers.first as! UIPageViewController
        
        reCommondViewController = HynReCommondViewController.getReCommondVC()
        newestViewController = HynNewestViewController.getNewestVC()
        
        viewControllersArray.append(reCommondViewController)
        viewControllersArray.append(newestViewController)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        //手动为pageViewController提供提一个页面
        pageViewController.setViewControllers([reCommondViewController], direction: .forward, animated: false, completion: nil)
        
    }
}

typealias HynHomeViewControllerNavBar = HynHomeViewController
// MARK: - 初始化navbar
extension HynHomeViewControllerNavBar {
    
    func setUpNavBar() {
        
        let leftBarItem:UIBarButtonItem = {
            
            let leftButton = UIButton.init(type: UIButtonType.custom)
            leftButton.frame = CGRect(x: 0, y: 0, width: 27, height: 27)
            leftButton.setImage(UIImage.init(named: "签到"), for: UIControlState.normal)
            leftButton.addTarget(self, action: #selector(signAction), for: UIControlEvents.touchUpInside)
            return UIBarButtonItem.init(customView: leftButton)
            
        }()
        
        setLeftBarButtonItem(barButtonItem: leftBarItem)
        
        segMentedControl.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.black], for: UIControlState.normal)
        segMentedControl.addTarget(self, action: #selector(segmentedAction(segment:)), for: .valueChanged)
    }
    
    @objc func segmentedAction(segment:UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            
            pageViewController.setViewControllers([reCommondViewController], direction: .forward, animated: false, completion: nil)
        }
        else if segment.selectedSegmentIndex == 1 {
            pageViewController.setViewControllers([newestViewController], direction: .reverse, animated: false, completion: nil)
        }
    }
    
    @objc func signAction() {
        print("sign")
    }
}


private typealias HynPageDataSource = HynHomeViewController
// MARK: - UIPageViewControllerDataSource
extension HynPageDataSource:UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: HynReCommondViewController.self) {
            return newestViewController
        }
        return nil
    }
}

typealias HynPageDelegate = HynHomeViewController
// MARK: - UIPageViewControllerDelegate
extension HynPageDelegate:UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            if (previousViewControllers.first?.isKind(of: HynReCommondViewController.self))! {
                segMentedControl.selectedSegmentIndex = 1
            }
            else {
                segMentedControl.selectedSegmentIndex = 0
            }
        }
    }
    
}



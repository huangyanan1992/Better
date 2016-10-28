//
//  HynHotBannerCell.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/18.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import UIKit
import Kingfisher

class HynHotBannerCell: UITableViewCell {

    @IBOutlet weak var cycleViewBg: UIView!
    var circleView:HynCircleView<String>?
    
    typealias ImageDidClick = (_ url:String) -> Void
    var imageClicked:ImageDidClick?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.width(), height: 205)
        HynHotModel.getBannerList { [weak self] (result, error) in
            guard result != nil else {
                return
            }
            self?.circleView = {
                let circleView = HynCircleView<String>(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (self?.bounds.height)!-5))
                self?.cycleViewBg.addSubview(circleView)
                let hotModelArray:[HynHotModel] = result!
                let images:[String] = hotModelArray.map({ (hotModel) -> String in
                    return hotModel.pic!
                })
                circleView.images = images
                circleView.imageDidClick = { [weak self] index  in
                    print("第\(index)张图片被点击了")
                    self?.imageClicked!((result?[index].target)!)
                    
                }
                circleView.addTimer()
                return circleView
            }()
            
        }
    }
    
    deinit {
        circleView?.removeTimer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

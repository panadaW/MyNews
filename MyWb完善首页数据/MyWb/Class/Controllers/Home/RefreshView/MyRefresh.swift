//
//  MyRefresh.swift
//  MyWb
//
//  Created by 王明申 on 15/10/15.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit

class MyRefresh: UIRefreshControl {
    private let kRefreshPullOffset: CGFloat = -60
//    重写结束刷新的方法
    override func endRefreshing() {
         super.endRefreshing()
        refreshView.endLoading()
    }

//KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        // 如果y > 0 直接返回
        if frame.origin.y > 0 {
            return
        }
        if refreshing {
         refreshView.stardRefresh()
        }
        if frame.origin.y < kRefreshPullOffset && !refreshView.rotateIcon {
//        下拉刷新图标
//            print("翻转过来")
            refreshView.rotateIcon = true
        } else if frame.origin.y > kRefreshPullOffset && refreshView.rotateIcon {
//        翻转图标
//        print("图标")
            refreshView.rotateIcon = false
        }
    }
    override init() {
        super.init()
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    self.removeObserver(self, forKeyPath: "frame")
    }
    

    func setUpUI() {
    addSubview(refreshView)
//        KVO监听frame变化，然后坐想要执行的代码
        self.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
               tintColor = UIColor.clearColor()
//        自动布局
        refreshView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: refreshView.bounds.size)
        
    }
    //    懒加载刷新控件
    lazy var refreshView: HMRefreshView = HMRefreshView.refreshV()
    

}
//    定义一个类属性
class HMRefreshView: UIView {
    private var rotateIcon = false {
        didSet {
//        旋转刷新
            refreshIconView()
        }
    }
    @IBOutlet weak var refreshview: UIImageView!
    @IBOutlet weak var tipview: UIView!
    @IBOutlet weak var iconview: UIImageView!
    //  加载xib
    class func refreshV() -> HMRefreshView {
        return NSBundle.mainBundle().loadNibNamed("MyrefreshView", owner: nil, options: nil).last as! HMRefreshView
        
    }

        //    旋转动画
  func refreshIconView() {
    let angel = self.rotateIcon ? CGFloat(M_PI - 0.01) : CGFloat(-M_PI + 0.01)
    UIView.animateWithDuration(0.25) { () -> Void in
    self.iconview.transform = CGAffineTransformRotate(self.iconview.transform, angel)
    }

}
//    开始刷新动画
    func stardRefresh() {
//如果动画被添加，则return
        if refreshview.layer.animationForKey("loadingAnim") != nil {
        return
        }
        //    隐藏旋转图标
        tipview.hidden = true
        
//        添加旋转动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 1.0
        refreshview.layer.addAnimation(anim, forKey: "loadingAnim")
    
    }
//    结束刷新动画
    func endLoading() {
    tipview.hidden = false
        refreshview.layer.removeAllAnimations()
    }
}


















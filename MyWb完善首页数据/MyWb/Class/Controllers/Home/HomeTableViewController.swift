//
//  HomeTableViewController.swift
//  MyWb
//
//  Created by 王明申 on 15/10/8.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController,HomeCellDelegate {

    var statues: [Status]? {
        didSet{
        tableView.reloadData()
        }
    }
    override func viewDidLoad() {
//        print(HMRefreshView())
        super.viewDidLoad()
        if TokenModel.loadToken == nil {
        visitorview?.changViewInfo(true, imagename: "visitordiscover_feed_image_smallicon", message: "关注一些人，回这里看看有什么惊喜")
        return
        }
        //        注册通知
        //        selector:监听方法，name：通知名
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "selectpicture:", name: MyPictureNotifitation, object: nil)
        prepareFortableView()
               loadstatus()
    }
    deinit {
        //        注销通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    
    }
//选中照片监听方法
   @objc private func selectpicture(n: NSNotification) {
//        获取参数
        guard let urls = n.userInfo![MyPictureUrlKey] as? [NSURL] else {
        print("图片数组不存在")
            return
        }
        // indexPath
        guard let indexPath = n.userInfo![MyPictureIndexPathKey] as? NSIndexPath else {
            print("indexPath 不存在")
            return
        }
//        传给照片查看器
        let vc = PhotoChoseViewController(url: urls, index: indexPath.item)
//    自定义专场动画
//    指定代理
    vc.transitioningDelegate = self
//    指定专场模式
    vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc, animated: true, completion: nil)
    
    }
    // MARK:注册cell
    private func prepareFortableView() {
    tableView.registerClass(flowhomeCell.self, forCellReuseIdentifier: "Wcell")
    tableView.registerClass(nomalHomecell.self, forCellReuseIdentifier: "Ncell")
//       tableView.rowHeight = 300
//       预估行高
        tableView.estimatedRowHeight = 300
//        tableView.rowHeight = UITableViewAutomaticDimension
//        取消分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //        刷新控件
        refreshControl = MyRefresh()
        
        refreshControl?.addTarget(self, action: "loadstatus", forControlEvents: UIControlEvents.ValueChanged)

    }

    // 上拉刷新的标记
    private var pullupRefreshFlag = false
    func loadstatus() {
//        刷新数据
        refreshControl?.beginRefreshing()
        var since_id = statues?.first?.id ?? 0
//        判断是否为上拉刷新
        var max_id = 0
        if pullupRefreshFlag {
        since_id = 0
        max_id = statues?.last?.id ?? 0

        }
                //加载用户数据
        Status.loadstatus(since_id,max_id: max_id ) {(dataList, error) -> () in
            self.refreshControl?.endRefreshing()
            if error != nil {
                print(error)
                return
            }
            let count = dataList?.count ?? 0
            print("刷新\(count)条数据)")
            if since_id > 0 {
            self.refreshInfro(count)
            }
            if count == 0 {
            return
            }
            if since_id > 0 {
          self.statues = dataList! + self.statues!
            } else if max_id > 0 {
//            上拉刷新
                self.statues! += dataList!
                self.pullupRefreshFlag = false
            }
            else {
            self.statues = dataList
            }
        }
    }
//   显示刷新信息
    func refreshInfro(count: Int) {
//        print(tipLable.layer.animationKeys())
        if tipLable.layer.animationForKey("position") != nil {
        print(" 动画正在执行")
            return
        }
        
    tipLable.text = (count == 0) ? "暂时没有新的微博" : "刷新到 \(count) 条微博"
//        设置标签初始位置
        let rect = tipLable.frame
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            UIView.setAnimationRepeatAutoreverses(true)
            self.tipLable.frame = CGRectOffset(rect, 0, rect.height * 3)
            }) { (_) -> Void in
                self.tipLable.frame = rect
        }
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statues?.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let status = statues![indexPath.row]
        if status.retweeted_status == nil{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Ncell", forIndexPath: indexPath) as! nomalHomecell
            cell.homeCellDelegate = self
            if indexPath.row == statues!.count - 1 {
//            设置上拉刷新标记
                pullupRefreshFlag = true
                loadstatus()
            }
            cell.status = statues![indexPath.row]
            return cell

        } else {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("Wcell", forIndexPath: indexPath) as! flowhomeCell
             cell.homeCellDelegate = self
            if indexPath.row == statues!.count - 1 {
                //            设置上拉刷新标记
                pullupRefreshFlag = true
                loadstatus()
            }

            cell.status = statues![indexPath.row]
            return cell
        }
    }
//    加载超链接文字
    func statusCellDidSelectedLinkText(text: String) {
        guard let url = NSURL(string: text) else {
        print("URL错误")
            return
        }
        let vc = HomeWeb()
        vc.url = url
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let status = statues![indexPath.row]
        
        if status.retweeted_status == nil {
            if  let h = status.rowHight {
                return h
            }
            let cell = tableView.dequeueReusableCellWithIdentifier("Ncell") as? nomalHomecell
            status.rowHight = cell!.setUpRowHight(status)
            return status.rowHight!
        } else {
            if  let h = status.rowHight {
                return h
            }
            let cell = tableView.dequeueReusableCellWithIdentifier("Wcell") as? flowhomeCell
            status.rowHight = cell!.setUpRowHight(status)
            return status.rowHight!
        }
    }
//    懒加载显示刷新信息的lable
    private lazy var tipLable: UILabel = {
        let h: CGFloat = 44
        let label = UILabel(frame: CGRect(x: 0, y: -2 * h, width: self.view.bounds.width, height: h))
        
        label.backgroundColor = UIColor.orangeColor()
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        
        // 加载 navBar 上面，不会随着 tableView 一起滚动
        self.navigationController?.navigationBar.insertSubview(label, atIndex: 0)
        return label

    }()
    
    /// 是否是 Modal 展现的标记
    private var isPresented = false

    }
///自定义专场协议
extension HomeTableViewController: UIViewControllerTransitioningDelegate {
//返回遵守协议的对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
//    返回解除转场的对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}
//自定义转床动画
extension HomeTableViewController: UIViewControllerAnimatedTransitioning {
//动画时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.8
    }
//实现专场方法
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
                let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        print(fromVC)
        print(toVC)
        if isPresented {
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!

//        将目标视图添加到容器视图中
        transitionContext.containerView()?.addSubview(toView)
        toView.alpha = 0
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            toView.alpha = 1.0
            }) { (_) -> Void in
                transitionContext.completeTransition(true)
        }
        }else {
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                
                fromView.alpha = 0.0
                
                }, completion: { (_) -> Void in
                    
                    fromView.removeFromSuperview()
                    
                    // 解除转场时，会把 容器视图以及内部的内容一起销毁
                    transitionContext.completeTransition(true)
            })

        
        
        }
    }
    }













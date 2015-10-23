//
//  MainViewController.swift
//  MyWb
//
//  Created by 王明申 on 15/10/8.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(HomeTableViewController(), title: "首页", imagename:"tabbar_home")
        addChildViewController(MessageTableViewController(), title: "消息", imagename:"tabbar_message_center")
        addChildViewController(UIViewController())
        
        addChildViewController(FinderTableViewController(), title: "查找", imagename:"tabbar_discover")
        addChildViewController(MineTableViewController(), title: "我的", imagename:"tabbar_profile")
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
       let btn = frameWithBtn()
        tabBar.addSubview(btn)
    }
//添加子控制器
    private func addChildViewController(v: UIViewController,title: String,imagename:String) {
        v.title = title
        v.tabBarItem.image = UIImage(named: imagename)
        let nav = UINavigationController(rootViewController: v)
       addChildViewController(nav)
       
    }
//    设置控件位置
    func frameWithBtn()->UIButton{
        let W = tabBar.frame.width/5
        
    styleBtn.frame = CGRectMake(W*2, 0, W, tabBar.frame.height)
     tabBar.addSubview(styleBtn)
    return styleBtn
    }
//    懒加载控件
    private lazy var styleBtn:UIButton = {
    let btn = UIButton()
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: "clickButten", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
//    按钮的监听事件撰写微博
    func clickButten(){
        let vc = (TokenModel.loadToken != nil) ? SendViewController() : OAuthViewController()
        let nav = UINavigationController(rootViewController: vc)
        presentViewController(nav, animated: true, completion: nil)
       
    }
}

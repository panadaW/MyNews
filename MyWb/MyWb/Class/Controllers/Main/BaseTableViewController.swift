//
//  BaseTableViewController.swift
//  MyWb
//
//  Created by 王明申 on 15/10/8.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController,VisitorLoadViewDelagate {
    let key = false
    //访客试图
    var visitorview: VisitorLoadView?
    override func viewDidLoad() {
        key ? super.viewDidLoad() : pickview()
    }
    func pickview(){
        visitorview = VisitorLoadView()
        visitorview?.delegata = self
        view = visitorview
        view.backgroundColor = UIColor.whiteColor()
//    设置状态栏
        
    }
    
//  执行代理方法
    func clickLoginButton() {
        let nav = UINavigationController(rootViewController: OAuthViewController())
        presentViewController(nav, animated: true, completion: nil)
    }

    func clickRegisterButton() {
        print("注册")
    }











}

//
//  OAuthViewController.swift
//  MyWb
//
//  Created by 王明申 on 15/10/9.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//
import SVProgressHUD
import UIKit
//用webview加载页面
class OAuthViewController: UIViewController,UIWebViewDelegate{
    
   private lazy var webview = UIWebView()
    override func loadView() {
        view = webview
        webview.delegate = self
        navigationItem.title = "英雄联盟"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
    }
//返回界面
    func close(){
        SVProgressHUD.dismiss()
    dismissViewControllerAnimated(true, completion: nil)
    
    }
//    代理方法
    func webViewDidStartLoad(webView: UIWebView) {
//        close()
    }
    func webViewDidFinishLoad(webView: UIWebView) {
//        close()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//加载授权页面
        webview.loadRequest(NSURLRequest(URL: NetWorkShare.shareTools.oauthUrl()))
        // Do any additional setup after loading the view.
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}

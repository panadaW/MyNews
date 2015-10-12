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
       SVProgressHUD.show()
    }
    func webViewDidFinishLoad(webView: UIWebView) {
       SVProgressHUD.dismiss()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//加载授权页面
        webview.loadRequest(NSURLRequest(URL: NetWorkShare.shareTools.oauthUrl()))
        // Do any additional setup after loading the view.
    }
//从请求的url中获取授权码
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request)
//        生成完整的字符串
        let urlstring = request.URL!.absoluteString
//        是否包含回调地址
        if !urlstring.hasPrefix(NetWorkShare.shareTools.redirectUri){
        return true
        }
        print(request.URL?.query)
        if let query = request.URL?.query where query.hasPrefix("code="){
        print("获取授权码")
            let code = query.substringFromIndex("code=".endIndex)
            print(code)
//            获取TOKEN
            loadToken(code)
        }
            else  {
            close()
            }
      return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//  获取Token方法
    func loadToken(coad: String) {
    NetWorkShare.shareTools.loadAccessToken(coad) { (resault, error) -> () in
        if error != nil || resault == nil {
        self.solveError()
            return
        }
//        保存账户到沙盒
//        加载用户信息
       TokenModel(dict: resault!).loadUserInfo({ (error) -> () in
            if error != nil {
            self.solveError()
            }else{
            print("保存信息成功")
            }
        })
        
//        print(tokenmodel)
//        NetWorkShare.shareTools.loadUserInfo(tokenmodel.uid!, finished: { (resault, error) -> () in
//            print(resault)
//        })
         }
    
    }

//   网络错误处理
    private func solveError(){
        SVProgressHUD.showInfoWithStatus("你的网络异常")
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1*NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
            self.close()
        })
    }
}

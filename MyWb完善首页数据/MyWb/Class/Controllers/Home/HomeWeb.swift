//
//  HomeWeb.swift
//  MyWb
//
//  Created by 王明申 on 15/10/26.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit
import SVProgressHUD
class HomeWeb: UIViewController,UIWebViewDelegate {
private let web = UIWebView()
    var url: NSURL?
    override func loadView() {
        view = web
        web.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if url != nil {
        web.loadRequest(NSURLRequest(URL: url!))
        }
        
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
}

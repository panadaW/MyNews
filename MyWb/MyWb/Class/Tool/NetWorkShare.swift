//
//  NetWorkShare.swift
//  MyWb
//
//  Created by 王明申 on 15/10/10.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit
import AFNetworking
class NetWorkShare: AFHTTPSessionManager {
//创建单例
    static let shareTools: NetWorkShare = {
    let urlBase = NSURL(string: "https://api.weibo.com/")
        let tool = NetWorkShare(baseURL: urlBase)
        tool.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as Set<NSObject>

        return tool
    }()
    // MARK: - OAuth授权
    private let clientId = "3024003065"
    private let appSecret = "757f69b385ced0c53c803f0f0814e1ef"
    /// 回调地址
    let redirectUri = "http://www.feng.com"

    /// 返回 OAuth 授权地址
    func oauthUrl() -> NSURL {
//        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(clientId)&redirect_uri=\(redirectUri)"
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=3024003065&redirect_uri=http://www.feng.com"

        return NSURL(string: urlString)!
    }
//    字典转模型
   
//根据授权码获取Token,使用回调，让试图控制器做想做的事
    func loadAccessToken (coad: String,finish: (resault :[String: AnyObject]?,error: NSError?)->()) {
        let urltoken = "https://api.weibo.com/oauth2/access_token"
        let paramar = ["client_id" :clientId,
                       "client_secret" :appSecret,
                       "grant_type" :"authorization_code",
                       "code" :coad,
                       "redirect_uri" :redirectUri,]
    POST(urltoken, parameters: paramar, success: { (_, JSON) -> Void in
        finish(resault: JSON as? [String : AnyObject], error: nil)
        }) { (_, error) -> Void in
            finish(resault: nil, error: error)
        }
    
    
    }




}

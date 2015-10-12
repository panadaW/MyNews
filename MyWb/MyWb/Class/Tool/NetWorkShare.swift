//
//  NetWorkShare.swift
//  MyWb
//
//  Created by 王明申 on 15/10/10.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit
import AFNetworking
/// 错误的类别标记
private let ErrorName = "xxxxxxxxxxx"
//网络回调起别名
typealias netFeedback = (resault :[String: AnyObject]?,error: NSError?)->()

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
//    网络方法枚举
    private enum netWorkMethod: String {
    case GET = "GET"
    case POST = "POST"
    }
//    错误信息
    private enum netWorkError: Int {
    case emptyDataError = -1
        case emptyTokenError = -2
//        描述错误信息
        private var errorDescription: String {
            switch self {
            case.emptyDataError: return "数据为空"
            case.emptyTokenError: return "Token为空"
            }
        }
        //    根据枚举类型，返回相应错误
        private func error()->NSError {
            return NSError(domain: ErrorName, code: rawValue, userInfo: [ErrorName: errorDescription])
        }
    }
//  加载用户信息
    func loadUserInfo(uid: String,finished:netFeedback) {
        if TokenModel.loadToken()?.access_token == nil{
          let error = netWorkError.emptyTokenError.error()
            print(error)
        return
        }
    let urlstring = "2/users/show.json"
        let parmeter: [String: AnyObject] = ["access_token":TokenModel.loadToken()!.access_token!,"uid": uid]
//        发送网络请求
//        requestGET(urlstring, parameters: parmeter, finish: finished)
        netWorkRequest(netWorkMethod.GET, coad: urlstring, paramet: parmeter, finish: finished)
    }

//根据授权码获取Token,使用回调，让试图控制器做想做的事
    func loadAccessToken (coad: String,finish: (resault :[String: AnyObject]?,error: NSError?)->()) {
        let urltoken = "https://api.weibo.com/oauth2/access_token"
        let paramar = ["client_id" :clientId,
                       "client_secret" :appSecret,
                       "grant_type" :"authorization_code",
                       "code" :coad,
                       "redirect_uri" :redirectUri,]
        netWorkRequest(netWorkMethod.POST, coad: urltoken, paramet: paramar, finish: finish)
    
    }

//   封装网络方法
   private func netWorkRequest(method:netWorkMethod,coad: String,paramet:[String: AnyObject],finish:netFeedback) {
//    定义成功闭包
        let finishBack: (NSURLSessionDataTask!, AnyObject!) -> Void = { (_,JSON) -> Void in
        
        if let resault = JSON as? [String: AnyObject] {
        
        finish(resault: resault, error: nil)
    }
    else {
        print("数据异常")
        let error = netWorkError.emptyTokenError.error()
        finish(resault: nil, error: error)
    }
    }
//   定义失败闭包
    let failedBack: (NSURLSessionDataTask!, NSError!) -> Void = { (_, error) -> Void in
    print(error)
    finish(resault: nil, error: error)
    }
    switch method {
    case.GET:
        GET(coad, parameters: paramet, success: finishBack, failure: failedBack)
    case.POST:
        POST(coad, parameters: paramet, success: finishBack, failure: failedBack)
    }
}
}
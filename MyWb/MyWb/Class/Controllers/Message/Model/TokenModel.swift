//
//  TokenModel.swift
//  MyWb
//
//  Created by 王明申 on 15/10/11.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit

class TokenModel: NSObject {
//设置属性
//用于调用access_token，接口获取授权后的access token。
    var access_token: String?
//access_token的生命周期，单位是秒数。
    var expires_in: NSTimeInterval = 10
//当前授权用户的UID。
    var uid: String?
//    字典转模型
    
    init(dict:[String: AnyObject]) {
    super.init()
    setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    override var description: String {
        let arrayP=["access_token","expires_in","uid"]
        return "\(dictionaryWithValuesForKeys(arrayP))"
        
    }
}

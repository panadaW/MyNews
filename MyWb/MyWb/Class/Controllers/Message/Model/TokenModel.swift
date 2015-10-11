//
//  TokenModel.swift
//  MyWb
//
//  Created by 王明申 on 15/10/11.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit

class TokenModel: NSObject, NSCoding {
//设置属性
//    用户名
    var name: String?
//    用户图片
    var avatar_large: String?
//用于调用access_token，接口获取授权后的access token。
    var access_token: String?
//access_token的生命周期，单位是秒数。
//    使用didset在给expires_in赋值时，给其设置其它属性
    var expires_in: NSTimeInterval = 10 {
        didSet {
         overData = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
//    过期日期
    var overData: NSDate?

    
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
        let arrayP=["access_token","expires_in","uid","overData"]
        return "\(dictionaryWithValuesForKeys(arrayP))"
        
    }
//  获取归档路径并保存
     static let tokenPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "/token.plist"
//  保存用户到磁盘
    func saveToken() {
    NSKeyedArchiver.archiveRootObject(self, toFile: TokenModel.tokenPath)
    }
//  加载用户,使用一个静态属性防止每次都从磁盘加载
   static var tokenmodel: TokenModel?
   class func loadToken()-> TokenModel?{
//        如果用户不存在（token）去沙盒加载
        if tokenmodel == nil{
//        解码
            tokenmodel = NSKeyedUnarchiver.unarchiveObjectWithFile(tokenPath) as? TokenModel
            return tokenmodel
        }
//        判断token是否过期，过期则为nil，否则返回该数据
    if let data = tokenmodel?.overData where data.compare(NSDate()) == NSComparisonResult.OrderedAscending{
     tokenmodel = nil
    }
    return tokenmodel
    }
//    归档，将自定义对象转换成二进制保存在磁盘
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(overData, forKey: "overData")
    }
    //    结档，将二进制数据转换成自定义对象
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        uid = aDecoder.decodeObjectForKey("uid") as? String
        overData = aDecoder.decodeObjectForKey("overData") as? NSDate
    }
    
    
    
}

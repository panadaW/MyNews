//
//  Status.swift
//  MyWb
//
//  Created by 王明申 on 15/10/13.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit
//微博数据模型
class Status: NSObject {
    // 微博创建时间
    var created_at: String?
    // 微博ID
    var id: Int = 0
    // 微博信息内容
    var text: String?
    // 微博来源
    var source: String?
    // 配图数组
    var pic_urls: [[String: AnyObject]]?
//    用户模型
    var user: UserModel?
   
//    把微博数据转换为数组
    class func loadstatus(finish:(dataList: [Status]?,error: NSError?)->() ){
        NetWorkShare.shareTools.loadStatus { (resault, error) -> () in
            if error != nil{
            
            return
            }
            if let array = resault?["statuses"] as? [[String: AnyObject]]{
//            实例化数组
            var list = [Status]()
//            遍历数组
            for dict in array {
//            字典转模型
                list.append(Status(dict: dict))
            }
                finish(dataList: list, error: nil)
            }else{
            finish(dataList: nil, error: nil)
            }
        }
    }
//字典转模型
     init(dict: [String: AnyObject]) {
       super.init()
       setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?,  forKey key: String) {
        
        if key == "user" {
//            判断 value 是否是一个字典，应为微博用户信息是用字典封装的
            if let dict = value as? [String: AnyObject] {
            user = UserModel(dict: dict)
            }
        return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    override var description: String {
        let keys = ["created_at","id","text","source","pic_urls"]
        return "\(dictionaryWithValuesForKeys(keys))"
    }

}
//
//  Status.swift
//  MyWb
//
//  Created by 王明申 on 15/10/13.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//
import SDWebImage
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
    var source: String? {
        didSet {
        source = source?.hrefLink().text
        }
    }
    // 配图数组
    var pic_urls: [[String: AnyObject]]? {
        didSet {
            if pic_urls?.count == 0 {
            return
            }
//        实例化数组
            storepictureURLs = [NSURL]()
            storedLargePictureURLs = [NSURL]()
//            遍历配图数组
            for dict in pic_urls! {
                if let urlstring = dict["thumbnail_pic"] as? String {
                storepictureURLs?.append(NSURL(string: urlstring)!)
               let largeurlstring = urlstring.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                    storedLargePictureURLs?.append(NSURL(string: largeurlstring)!)
                 
                }
                
            
            }
        
        }
    
    }
//    存储转发微博图片数组，或原创微博url数组
    var storepictureURLs: [NSURL]?
//    微博配图URL数组
    var pictureURLs: [NSURL]? {
        return retweeted_status == nil ? storepictureURLs : retweeted_status?.storepictureURLs
    }
//    定义大图URL数组
    var storedLargePictureURLs: [NSURL]?
    
//    返回大图URL数组
    var largePictureURLs: [NSURL]? {
        return retweeted_status == nil ? storedLargePictureURLs : retweeted_status?.storedLargePictureURLs
    
    }
//    用户模型
    var user: UserModel?
// 转发微博
    var retweeted_status: Status?
//    行高属性
    var rowHight: CGFloat?
//    把微博数据转换为数组
    class func loadstatus(since_id: Int,max_id: Int,finish:(dataList: [Status]?,error: NSError?)->() ){
        NetWorkShare.shareTools.loadStatus(since_id,max_id: max_id) { (resault, error) -> () in
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
//                缓存图片
                self.cacheImage(list, finish: finish)
                           }else{
            finish(dataList: nil, error: nil)
            }
        }
    }
//    缓存网络图片，等缓存完毕，才能刷新数据
    private class func cacheImage(list: [Status],finish:(dataList: [Status]?,error: NSError?)->()) {
//    创建调度组
        let group = dispatch_group_create()
//        缓存图片大小
        var dadtaLengh = 0
//    遍历数组
        for status in list {
            guard let url = status.pictureURLs else {
            continue
            }
//        遍历url数组，缓存图片
            for imgurl in url {
            dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(imgurl, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, _, _, _, _) -> Void in
//                    将图片转换为二进制
                    if image != nil {
                    let data = UIImagePNGRepresentation(image)!
                    dadtaLengh += data.length
                    }
//                    出组
                    dispatch_group_leave(group)
                    
                })
            
            }
        }
//    监听缓存操作通知
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            print("缓存图片大小 \(dadtaLengh / 1024) K")
//            回调
            finish(dataList: list, error: nil)
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
        if key == "retweeted_status" {
            if let dict = value as? [String: AnyObject] {
           retweeted_status = Status(dict: dict)
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
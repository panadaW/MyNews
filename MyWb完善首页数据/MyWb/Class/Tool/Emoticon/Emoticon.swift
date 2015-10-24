//
//  Emoticon.swift
//  测试-01-表情键盘
//
//  Created by teacher on 15/8/5.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

/**
    1. Emoticons.bundle的根目录中有一个 emoticons.plist 
        packages数组的每一项字典中的 id 对应的是每一套表情的目录名
    2. 每一个表情目录下，都有一个 info.plist 文件
        group_name_cn 记录的表情包的名字
        emoticons 数组，记录的整套表情的数组
    3. 表情字典信息
        chs:    定义的发布微博以及网络传输使用的微博文字字符串
        png:    在客户端显示的图片名称

        code:   emoji要显示的16进制字符串！
*/

/// 表情包模型 - 从 emoticons.plist 加载
/**
    0. 最近
    1. 默认
    2. emoji
    3. 浪小花
*/
class EmoticonPackage: NSObject {
    /// 目录名
    var id: String
    /// 分组名
    var groupName: String = ""
    /// 表情数组
    var emoticons: [Emoticon]?
    
    // 默认值可以做到对之前的代码不做任何调整
    init(id: String, groupName: String = "") {
        self.id = id
        self.groupName = groupName
    }
    
    /// 添加最近使用的表情 - 仅往第 0 个分组添加
    /// 仅是内存排序！
    class func addFavorate(emoticon: Emoticon) {
        
        // 0. 判断是否是删除按钮
        if emoticon.removeEmoticon {
            return
        }
        
        // 1. 拿到第0个分组包的数组
        var ems = packages[0].emoticons
        // 1.1 删除末尾的删除按钮，后续对数组的操作，删除按钮不参与
        ems?.removeLast()
        
        // 2. 递增表情的使用次数
        emoticon.times++
        
        // 3. 添加 emoticon
        // 3.1 判断数组中是否已经包含表情
        let contains = ems!.contains(emoticon)
        if !contains {
            ems!.append(emoticon)
        }
        
        // 4. 排序表情数组
//        ems = ems!.sort { (e1, e2) -> Bool in
//            return e1.times > e2.times
//        }
        // 排序的简写
        ems = ems!.sort { return $0.times > $1.times }
        
        // 5. 将末尾的表情删掉 － 始终保持 21 个表情
        if !contains {
            ems?.removeLast()
        }
        // 5.1 重新追加删除按钮
        ems?.append(Emoticon(remove: true))
        
        // 6. 重新设置表情数组
        packages[0].emoticons = ems
        
        print("\(ems) 数组数量 \(ems!.count)")
    }
    
    /// 使用`静态`常量只允许被设置一次数值，变量的写法和单例几乎一致
    static let packages = EmoticonPackage.loadPackages()
    /// 加载所有的表情包 － 每次都会被撰写微博控制器重复加载
    /// 但是表情包的使用频率非常高！
    private class func loadPackages() -> [EmoticonPackage] {
        print("加载表情包数据...")
        
        // 1. 加载路径
        let path = bundlePath.stringByAppendingString("/emoticons.plist")
//        print(path)
        
        // 2. 加载 plist
        let dict = NSDictionary(contentsOfFile: path)!
        let array = dict["packages"] as! [[String: AnyObject]]
        
        var arrayM = [EmoticonPackage]()
        
        // !!! - 插入最近表情包(追加空表情－在界面上占位)
        let package = EmoticonPackage(id: "", groupName: "最近AA").appendEmptyEmotions()
        arrayM.append(package)
        
        // 3. 遍历数组
        for d in array {
            let id = d["id"] as! String
            // 链式响应
            let package = EmoticonPackage(id: id).loadEmoticons().appendEmptyEmotions()
            
            arrayM.append(package)
        }
        
        return arrayM
    }
    
    /// 加载当前对象对应的表情数组，从 info.plist 中加载并完成完整的模型信息
    /// Self 表示返回本类的对象
    private func loadEmoticons() -> Self {
        
        // 1. 路径
        let path = EmoticonPackage.bundlePath.stringByAppendingString(id).stringByAppendingString("/info.plist")
        
        let dict = NSDictionary(contentsOfFile: path)!
        
        groupName = dict["group_name_cn"] as! String
        let array = dict["emoticons"] as! [[String: String]]
        
        // 2. 遍历数组 － 每隔20个表情插入一个`删除`表情
        emoticons = [Emoticon]()
        
        var index = 0
        for d in array {
            // 将表情包的 id 传递给 表情，方便拼接路径
            emoticons?.append(Emoticon(id: id, dict: d))
            
            index++
            // 插入删除表情
            if index == 20 {
                emoticons?.append(Emoticon(remove: true))
                index = 0
            }
        }
        
        return self
    }
    
    /// 在表情数组中追加空白表情 - 如果最后一页不是 21 个表情，追加空白表情，并且最后一个放删除按钮
    private func appendEmptyEmotions() -> Self {
        
        // 判断表情数组是否存在
        if emoticons == nil {   // 最近分组
            emoticons = [Emoticon]()
        }
        
        // 判断是否整页
        let count = emoticons!.count % 21
        
        print("已经有 \(count) 个表情")
        
        // count == 0 表示整页不需要追加，同时如果没有任何表情，就追加一个空页
        if count > 0 || emoticons!.count == 0 {
            for _ in count..<20 {
                emoticons?.append(Emoticon(remove: false))
            }
            // 最末尾追加一个删除按钮
            emoticons?.append(Emoticon(remove: true))
        }
        return self
    }
    
    /// 表情包的路径
    private static let bundlePath = NSBundle.mainBundle().bundlePath.stringByAppendingString("/Emoticons.bundle/")
    
    
    override var description: String {
        return "\(id) \(groupName) \(emoticons)"
    }
}

/// 表情模型
class Emoticon: NSObject {
    /// 表情目录
    var id: String?
    
    /// 发送给服务器的表情文字
    var chs: String?
    /// 本地显示的图片文件名
    var png: String?
    /// 图片完整路径
    var imagePath: String {
        // 判断是否是`图片`表情
        if chs == nil {
            return ""
        }
        
        // bundlePath + id + png
        return EmoticonPackage.bundlePath.stringByAppendingString(id!).stringByAppendingString(png!)
    }
    
    /// emoji 的代码
    var code: String? {
        didSet {
            // 扫描器
            let scanner = NSScanner(string: code!)
            
            var value: UInt32 = 0
            scanner.scanHexInt(&value)
            
            emoji = String(Character(UnicodeScalar(value)))
        }
    }
    /// emoji 字符串
    var emoji: String?
    
    /// 删除表情标记
    var removeEmoticon = false
    /// 表情使用次数
    var times = 0
    
    init(remove: Bool) {
        removeEmoticon = remove
    }
    
    init(id: String, dict: [String: String]) {
        self.id = id
        
        super.init()
        
        // 会根据 字典中的 值对 顺序调用 setValueForKey(key存在)
        setValuesForKeysWithDictionary(dict)
    }

    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String {
        return "\(chs) \(png) \(code) \(removeEmoticon)"
    }
}

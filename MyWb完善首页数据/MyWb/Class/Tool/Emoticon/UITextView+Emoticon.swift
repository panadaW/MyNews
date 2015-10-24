//
//  UITextView+Emoticon.swift
//  测试-01-表情键盘
//
//  Created by teacher on 15/8/5.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

extension UITextView {
    
    /// 插入表情符号
    ///
    /// :param: emoticon 表情符号
    func insertEmoticon(emoticon: Emoticon) {
        
        // 0. 删除文本
        if emoticon.removeEmoticon {
            deleteBackward()
            
            return
        }
        
        // 1. emoji 本质上就是一个字符串，可以直接在网络中传输
        if emoticon.emoji != nil {
            replaceRange(selectedTextRange!, withText: emoticon.emoji!)
            
            return
        }
        
        // 2. 表情图片
        if emoticon.chs != nil {
            
            // 1. 创建图片属性字符串
            let attachment = EmoticonAttachment()
            // 记录表情文字
            attachment.chs = emoticon.chs
            
            attachment.image = UIImage(contentsOfFile: emoticon.imagePath)
            // 设置边界
            let h = font!.lineHeight
            print("线高 \(h)")
            // 提示：在 scrollView 中，bounds 的原点 就是 contentOffset
            attachment.bounds = CGRect(x: 0, y: -4, width: h, height: h)
            
            let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
            
            // 添加文本字体属性
            // name: 属性的名称
            // value: 属性值
            imageText.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(0, 1))
            
            // 2. 图片文字插入到 textView
            // 1> 获取可变的属性文本
            let attrString = NSMutableAttributedString(attributedString: attributedText)
            // 2> 插入图片文字
            attrString.replaceCharactersInRange(selectedRange, withAttributedString: imageText)
            
            // 3> 使用可变属性文本替换文本视图的内容
            // 1) 记录光标位置
            let range = selectedRange
            // 2) 设置内容
            attributedText = attrString
            // 3) 恢复光标位置
            selectedRange = NSRange(location: range.location + 1, length: 0)
            
            // 3. 主动调用代理方法，满足某个条件时，通知代理去工作！
            delegate?.textViewDidChange!(self)
        }
    }
    
    // 对属性文本进行检测，并且拼接返回一个字符串
    /// 计算型属性，返回完整字符串
    var emoticonText: String {
        
        // 属性文本是分段保存的，能否把每一个分段拿到
        let attrString = attributedText
        var strM = String()
        
        attrString.enumerateAttributesInRange(NSMakeRange(0, attrString.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict, range, _) in
            
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                strM += attachment.chs!
            } else {
                // 使用 range 获取文本内容
                let str = (attrString.string as NSString).substringWithRange(range)
                strM += str
            }
        }
        
        return strM
    }
}


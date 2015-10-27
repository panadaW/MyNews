//
//  EmoticonAttachment.swift
//  测试-01-表情键盘
//
//  Created by teacher on 15/8/5.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

class EmoticonAttachment: NSTextAttachment {
    // 记录表情符号
    var chs: String?
    /// 通过表情符号，建立一个使用 `EmoticonAttachment` 建立的属性文本
    class func imageText(emoticon: Emoticon, font: UIFont) -> NSAttributedString {
        // 1. 创建图片属性字符串
        let attachment = EmoticonAttachment()
        // 记录表情文字
        attachment.chs = emoticon.chs
        
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath)
        // 设置边界
        let h = font.lineHeight
        // 提示：在 scrollView 中，bounds 的原点 就是 contentOffset
        attachment.bounds = CGRect(x: 0, y: -4, width: h, height: h)
        
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        
        // 添加文本字体属性
        // name: 属性的名称
        // value: 属性值
        imageText.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, 1))
        
        return imageText
    }






}

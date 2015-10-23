//
//  UIBarButtonItem+Extention.swift
//  MyWb
//
//  Created by 王明申 on 15/10/23.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit
extension UIBarButtonItem {
    convenience init(imageName: String, target: AnyObject?, action: String?) {
        let button = UIButton()
        
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        button.sizeToFit()
        
        // 设置监听方法，判断 action 是否存在
        if let actionName = action {
            button.addTarget(target, action: Selector(actionName), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        // 调用指定的构造函数
        self.init(customView: button)
    }



}
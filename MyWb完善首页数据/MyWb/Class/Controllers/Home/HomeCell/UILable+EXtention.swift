//
//  UILable+EXtention.swift
//  MyWb
//
//  Created by 王明申 on 15/10/13.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit
//类扩展只能用便利函数
extension UILabel {

    convenience init(color: UIColor, fontSize: CGFloat) {
    self.init()
        textColor = color
        font = UIFont.systemFontOfSize(fontSize)
    
    }

}
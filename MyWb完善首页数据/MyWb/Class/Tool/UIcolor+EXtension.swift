//
//  UIcolor+EXtension.swift
//  MyWb
//
//  Created by 王明申 on 15/10/20.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit
extension UIColor {
//    随机生成颜色
    class func radomColor()->UIColor {
    return UIColor(red: radomVaule(), green: radomVaule(), blue: radomVaule(), alpha: 1.0)
    }
    
    private class func radomVaule()->CGFloat {
    return CGFloat(arc4random_uniform(256))/255
    }
}

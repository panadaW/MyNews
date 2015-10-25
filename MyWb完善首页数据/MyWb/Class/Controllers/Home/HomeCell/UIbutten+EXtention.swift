//
//  UIbutten+EXtention.swift
//  MyWb
//
//  Created by 王明申 on 15/10/13.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit
extension UIButton {
    convenience init(title: String, imageName: String, fontSize: CGFloat = 12, color: UIColor = UIColor.darkGrayColor()) {
        
        self.init()
        
        setTitle(title, forState: UIControlState.Normal)
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setTitleColor(color, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    convenience init(title: String, fontSize: CGFloat = 12, color: UIColor = UIColor.darkGrayColor(), backColor: UIColor = UIColor.whiteColor()) {
        
        self.init()
        
        setTitle(title, forState: UIControlState.Normal)
        setTitleColor(color, forState: UIControlState.Normal)
        backgroundColor = backColor
        
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    convenience init(imageName: String) {
        self.init()
        
        setImage(imageName)
    }
    
    func setImage(imageName: String) {
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
    }


}
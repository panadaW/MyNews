//
//  nomalHomecell.swift
//  MyWb
//
//  Created by 王明申 on 15/10/17.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit

class nomalHomecell: homeCell {

    override func setupUI() {
        super.setupUI()
        //3 图片视图约束
           let ary = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLable, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: 8))
            pictureWidthCons = pictureView.ff_Constraint(ary, attribute: NSLayoutAttribute.Width)
            pictureHeightCons = pictureView.ff_Constraint(ary, attribute: NSLayoutAttribute.Height)
            pictureTopCons = pictureView.ff_Constraint(ary, attribute: NSLayoutAttribute.Top)
    }
}

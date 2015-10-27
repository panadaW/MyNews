//
//  flowhomeCell.swift
//  MyWb
//
//  Created by 王明申 on 15/10/16.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit

class flowhomeCell: homeCell {
    override var status: Status? {
        didSet {
    let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            forwardlable.text = "@" + name + ":" + text
        
        }
    
    }
//重写布局方法
    override func setupUI() {
        super.setupUI()
//添加控件
        contentView.insertSubview(backButten, belowSubview: pictureView)
        contentView.insertSubview(forwardlable,aboveSubview: backButten)
//设置背景按钮布局
        backButten.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLable, size: nil, offset: CGPoint(x: -statusCellControlMargin, y: statusCellControlMargin))
        backButten.ff_AlignVertical(type: ff_AlignType.TopRight, referView: bottomView, size: nil)
//转发文本布局
        forwardlable.ff_AlignInner(type: ff_AlignType.TopLeft, referView: backButten, size: nil, offset: CGPointMake(statusCellControlMargin, statusCellControlMargin))
//3 图片视图约束
        let ary = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: forwardlable, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: 8))
        pictureWidthCons = pictureView.ff_Constraint(ary, attribute: NSLayoutAttribute.Width)
        pictureHeightCons = pictureView.ff_Constraint(ary, attribute: NSLayoutAttribute.Height)
        pictureTopCons = pictureView.ff_Constraint(ary, attribute: NSLayoutAttribute.Top)
   
    
    }
//   懒加载转发文字
    lazy var forwardlable: FFLabel = {
    let lab = FFLabel(color: UIColor.darkGrayColor(), fontSize: 14)
        lab.numberOfLines = 0
        lab.labelDelegate = self
        lab.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * statusCellControlMargin
        return lab
    }()
    
//    懒加载一个Butten
    lazy var backButten: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return btn
        
        }()
}

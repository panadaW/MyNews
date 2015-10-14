//
//  homeCell.swift
//  MyWb
//
//  Created by 王明申 on 15/10/13.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit

class homeCell: UITableViewCell {
    var status: Status? {
        didSet {
           topview.status = status
            contentLable.text = status?.text ?? ""
        }
    }
       // MARK: - 界面设置
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   private func setupUI() {
    contentView.addSubview(topview)
    contentView.addSubview(contentLable)
    contentView.addSubview(bottomView)
  //顶部视图布局
    topview.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 53))
//   设置内容视图的约束
    contentLable.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topview, size: nil, offset: CGPoint(x: 8, y: 8))
    // 宽度
    contentView.addConstraint(NSLayoutConstraint(item: contentLable, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: -16))
//  底部视图约束
    // 3> 底部视图
    bottomView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLable, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44), offset: CGPoint(x: -8, y: 8))
//    // 底部约束
    contentView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))

    
    }
//    懒加载顶部试图
    lazy var topview: topView = topView()
// 懒加载内容视图
    lazy var contentLable: UILabel = {
    let lable = UILabel(color: UIColor.darkGrayColor(), fontSize: 15)
        lable.numberOfLines = 0
        return lable
    }()
    /// 底部视图
    lazy var bottomView: BottomView = BottomView()

    
}

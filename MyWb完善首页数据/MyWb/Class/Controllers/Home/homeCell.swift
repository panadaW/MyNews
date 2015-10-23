//
//  homeCell.swift
//  MyWb
//
//  Created by 王明申 on 15/10/13.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit
let statusCellControlMargin: CGFloat = 8.0

class homeCell: UITableViewCell {
    var status: Status? {
        didSet {
           topview.status = status
            contentLable.text = status?.text ?? ""
            pictureView.status = status
           
//            设置配图宽高
            pictureWidthCons?.constant = pictureView.bounds.width
            pictureHeightCons?.constant = pictureView.bounds.height
            pictureTopCons?.constant = (pictureView.bounds.height == 0) ? 0 : statusCellControlMargin
        }
    }
//    设置图片视图的宽高约束,因为图片数量不等，所以导致宽高不等，不能用估值行高
    var pictureWidthCons: NSLayoutConstraint?
    var pictureHeightCons: NSLayoutConstraint?
//    图片顶部约束
    var pictureTopCons: NSLayoutConstraint?
//设置行高
    func setUpRowHight(status: Status)->CGFloat{
    self.status = status
//        根据获取的数据，相应的更新布局
        layoutIfNeeded()
//        返回底部视图最大高度
        return CGRectGetMaxY(bottomView.frame)
    }
       // MARK: - 界面设置
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI() {
    contentView.addSubview(topview)
    contentView.addSubview(contentLable)
    contentView.addSubview(pictureView)
    contentView.addSubview(bottomView)
//1 顶部视图布局
    topview.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 53))
//2 设置内容视图的约束
    contentLable.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topview, size: nil, offset: CGPoint(x: 8, y: 8))
//  宽度
    contentView.addConstraint(NSLayoutConstraint(item: contentLable, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: -16))
//3 图片视图约束
//   let ary = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLable, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: 8))
//    pictureWidthCons = pictureView.ff_Constraint(ary, attribute: NSLayoutAttribute.Width)
//    pictureHeightCons = pictureView.ff_Constraint(ary, attribute: NSLayoutAttribute.Height)
//    pictureTopCons = pictureView.ff_Constraint(ary, attribute: NSLayoutAttribute.Top)
//4 底部视图
    bottomView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44), offset: CGPoint(x: -8, y: 8))
//5 底部约束
//    contentView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))

    
    }
//    懒加载顶部试图
    lazy var topview: topView = topView()
// 懒加载内容视图
        lazy var contentLable: UILabel = {
    let lable = UILabel(color: UIColor.darkGrayColor(), fontSize: 15)
        lable.numberOfLines = 0
        lable.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * statusCellControlMargin
        return lable
    }()
//    懒加载图片视图
    lazy var pictureView: PictureView = PictureView()
    /// 底部视图
    lazy var bottomView: BottomView = BottomView()

    
}

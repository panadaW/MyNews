//
//  BottomView.swift
//  MyWb
//
//  Created by 王明申 on 15/10/13.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit

class BottomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func setUpUI() {
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
//    添加控件
        addSubview(forwardButton)
        addSubview(commentButton)
        addSubview(likeButton)
        //        设置约束
        ff_HorizontalTile([forwardButton, commentButton, likeButton], insets: UIEdgeInsetsZero)
        
    }
//    懒加载控件
    private lazy var forwardButton: UIButton = UIButton(title: " 转发", imageName: "timeline_icon_retweet")
    private lazy var commentButton: UIButton = UIButton(title: " 评论", imageName: "timeline_icon_comment")
    private lazy var likeButton: UIButton = UIButton(title: " 赞", imageName: "timeline_icon_unlike")
    
}

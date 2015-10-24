//
//  EmoticonViewController.swift
//  测试-01-表情键盘
//
//  Created by teacher on 15/8/5.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

/// Cell的标示符
private let HMEmoticonCellIdentifier = "HMEmoticonCellIdentifier"

/// 表情键盘输入控制器
class EmoticonViewController: UIViewController {

    // 定义一个选择表情的闭包
    /// 选择表情的回调
    var selectedEmoticonCallBack: (emoticon: Emoticon) -> ()
    
    // MARK: - 构造函数
    init(selectedEmoticon: (emoticon: Emoticon) -> ()) {
        // 1. 记录闭包
        selectedEmoticonCallBack = selectedEmoticon
        
        // 2. 调用指定的构造函数
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 监听方法
    /// 选中工具栏按钮
    func clickItem(item: UIBarButtonItem) {
        // 滚动到对应的分组
        let indexPath = NSIndexPath(forItem: 0, inSection: item.tag)
        
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - 搭建界面
    func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(toolbar)
        
        // 自动布局 - 开发相对独立的程序或者框架时，最好不要用其他框架
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        let viewDict = ["cv": collectionView, "tb": toolbar]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-0-[tb(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        
        // 准备控件
        prepareToolbar()
        prepareCollectionView()
    }
    
    /// 准备 cv
    private func prepareCollectionView() {
        collectionView.registerClass(EmoticonCell.self, forCellWithReuseIdentifier: HMEmoticonCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor.whiteColor()
    }
    
    /// 准备工具栏
    private func prepareToolbar() {
        toolbar.tintColor = UIColor.darkGrayColor()
        
        var items = [UIBarButtonItem]()
        var index = 0
        for p in packages {
            items.append(UIBarButtonItem(title: p.groupName, style: UIBarButtonItemStyle.Plain, target: self, action: "clickItem:"))
            items.last?.tag = index++
            
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        
        toolbar.items = items
    }
    
    // MARK: - 懒加载
    /// 表情包数据
    private lazy var packages = EmoticonPackage.packages
    
    private lazy var toolbar = UIToolbar()
    private lazy var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: HMEmoticonLayout())
    
    /// 表情键盘布局 - 私有类
    private class HMEmoticonLayout: UICollectionViewFlowLayout {
        
        private override func prepareLayout() {
            
            // 设置布局属性
            let w = collectionView!.bounds.width / 7.0
            // 提示：由于浮点数计算的问题，如果是 0.5，在 iPhone 4s 的模拟器，只能显示 2 行
            // 工作中，实际测试一定要测试所有的屏幕！
            let y = (collectionView!.bounds.height - 3 * w) * 0.499
            itemSize =  CGSize(width: w, height: w)
            
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            sectionInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
            
            scrollDirection = UICollectionViewScrollDirection.Horizontal
            collectionView?.pagingEnabled = true
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
}

extension EmoticonViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // 1. 获取到当前选中的表情
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        
        // 2. 完成回调
        selectedEmoticonCallBack(emoticon: emoticon)
        
        // 3. 添加最近的表情 - 如果用户使用的是最近的表情，就不参加排序
        if indexPath.section > 0 {
            EmoticonPackage.addFavorate(emoticon)
        }
        
        // 4. 刷新数据，第0分组
        // 用户体验：一个界面会闪动，表情变化位置，用户体验不好
        // collectionView.reloadSections(NSIndexSet(index: 0))
    }
    
    /// 返回分组数量 - 返回表情包的数量
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    /// 返回每个表情包中，表情的数量
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HMEmoticonCellIdentifier, forIndexPath: indexPath) as! EmoticonCell
        
        cell.emoticon = packages[indexPath.section].emoticons![indexPath.item]
        
        return cell
    }
}

/// 表情 Cell
private class EmoticonCell: UICollectionViewCell {
    
    /// 表情
    var emoticon: Emoticon? {
        didSet {
            // 设置按钮的图像
            // contentsOfFile 如果路径不存在(图像不存在)，会返回 nil，setImage -> 清空按钮的图片
            emoticonButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath), forState: UIControlState.Normal)
            // 设置 emoji
            emoticonButton.setTitle(emoticon!.emoji, forState: UIControlState.Normal)
            
            // 判断是否是删除按钮
            if emoticon!.removeEmoticon {
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
            }
        }
    }
    
    // 提示：frame 已经有准确的数值，frame的数值来源是
    override init(frame: CGRect) {
        super.init(frame: frame)

        emoticonButton.backgroundColor = UIColor.whiteColor()
        // 设定相对 bounds 的缩进后的 rect
        emoticonButton.frame = CGRectInset(bounds, 4, 4)
        // 设置按钮字体，调整 emoji 的显示大小
        emoticonButton.titleLabel?.font = UIFont.systemFontOfSize(32)
        // 禁用按钮交互，让代理接管交互
        emoticonButton.userInteractionEnabled = false
        addSubview(emoticonButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 懒加载控件
    private lazy var emoticonButton = UIButton()
}

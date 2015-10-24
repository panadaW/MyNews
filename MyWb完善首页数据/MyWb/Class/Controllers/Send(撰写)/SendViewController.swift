//
//  SendViewController.swift
//  MyWb
//
//  Created by 王明申 on 15/10/23.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit
import SVProgressHUD
class SendViewController: UIViewController,UITextViewDelegate {
    /// 表情键盘控制器
    private lazy var emoticonVC: EmoticonViewController = EmoticonViewController { [weak self] emoticon in
        self?.textView.insertEmoticon(emoticon)
    }

    override func loadView() {
        view = UIView()
            view.backgroundColor = UIColor.whiteColor()
        prepareNAV()
        prepareToolBar()
        prepareTextView()
    }
    // 准备文本框
    private func prepareTextView() {
        view.addSubview(textView)
        textView.backgroundColor = UIColor.whiteColor()
        
        print(automaticallyAdjustsScrollViewInsets)
        // 自动布局
        // 提示：在 iOS 开发中，如果是单纯的 nav + scrollView 会自动调整滚动视图的边距
        textView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        textView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: view, size: nil)
        textView.ff_AlignVertical(type: ff_AlignType.TopRight, referView: toolbar, size: nil)
        
        // 添加占位标签
        placeholderLabel.text = "分享新鲜事..."
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: textView, size: nil, offset: CGPoint(x: 5, y: 8))
        
        // 添加长度提示标签 － 一定添加到 `view` 上
        // 在向 scrollView 中添加控件时，指定自动布局特别麻烦(左上角除外)
        // (需要增加一个view，专门来设置 scrollView 的 contentSize)
        view.addSubview(lengthTipLabel)
//        lengthTipLabel.text = String(kStatusTextMaxLength)
        lengthTipLabel.sizeToFit()
        lengthTipLabel.ff_AlignInner(type: ff_AlignType.BottomRight, referView: textView, size: nil, offset: CGPoint(x: -8, y: -8))
    }

//    准备toolbar
    func prepareToolBar() {
        toolbar.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        view.addSubview(toolbar)
//        设置布局
        let cons = toolbar.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44))
        toolbarBottomCons = toolbar.ff_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
//        定义数组描述控件
        let itemSettings = [["imageName": "compose_toolbar_picture"],
            ["imageName": "compose_mentionbutton_background"],
            ["imageName": "compose_trendbutton_background"],
            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
            ["imageName": "compose_addbutton_background"]]
var items = [UIBarButtonItem]()
        for dict in itemSettings {
                   items.append(UIBarButtonItem(imageName: dict["imageName"]!, target: self, action: dict["action"]))
            //追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolbar.items = items
    }
   //准备导航栏
    func prepareNAV() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "send")
        navigationItem.rightBarButtonItem?.enabled = false
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 32))
        
        let titleLabel = UILabel(color: UIColor.darkGrayColor(), fontSize: 15)
        titleLabel.text = "发微博"
        titleLabel.sizeToFit()
        titleView.addSubview(titleLabel)
        titleLabel.ff_AlignInner(type: ff_AlignType.TopCenter, referView: titleView, size: nil)
        
        let nameLabel = UILabel(color: UIColor.lightGrayColor(), fontSize: 13)
        nameLabel.text = TokenModel.loadToken?.name ?? ""
        nameLabel.sizeToFit()
        titleView.addSubview(nameLabel)
        nameLabel.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: titleView, size: nil)
        
        navigationItem.titleView = titleView
    
    }
    func close() {

        textView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    func send() {
    
        NetWorkShare.shareTools.sendStatus(textView.emoticonText) { (resault, error) -> () in
            if error != nil {
            SVProgressHUD.showInfoWithStatus("网络不给力", maskType: SVProgressHUDMaskType.Gradient)
                return
            }
            self.close()
        }
    }
     func inputEmoticon() {
        print("选择表情\(textView.inputView)")
        textView.resignFirstResponder()
        textView.inputView = (textView.inputView == nil) ? emoticonVC.view : nil
        textView.becomeFirstResponder()
    }
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardOberserver()
    }
    deinit {
    removeKeyboardOberserver()
    }
//添加键盘通知
    private func addKeyboardOberserver() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
//    删除键盘通知
    private func removeKeyboardOberserver() {
    NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    /// toolbar 底部约束
    private var toolbarBottomCons: NSLayoutConstraint?
//    键盘监听方法
     func keyboardChanged(n:NSNotification) {
        // 获取目标 frame
        let rect = n.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        // 动画时长
        let duration = n.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        
        // 设置约束
        toolbarBottomCons?.constant = -(UIScreen.mainScreen().bounds.height - rect.origin.y)
        
        // 动画
        UIView.animateWithDuration(duration) { () -> Void in
            self.view.layoutIfNeeded()
        }

    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
//        激活键盘
        textView.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: 懒加载控件
    /// 文本视图
    private lazy var textView: UITextView = {
        let tv = UITextView()
        
        tv.font = UIFont.systemFontOfSize(18)
        // 设置代理
        tv.delegate = self
        
        // 允许垂直拖拽
        tv.alwaysBounceVertical = true
        // 拖拽关闭键盘
        tv.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        return tv
        }()

    /// 占位标签
    private lazy var placeholderLabel = UILabel(color: UIColor.lightGrayColor(), fontSize: 18)
    /// 长度提示标签
    private lazy var lengthTipLabel = UILabel(color: UIColor.lightGrayColor(), fontSize: 12)
    
    /// 工具栏
    private lazy var toolbar = UIToolbar()

}

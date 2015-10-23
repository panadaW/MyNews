//
//  PhotoChose.swift
//  MyWb
//
//  Created by 王明申 on 15/10/20.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit
import SVProgressHUD
class PhotoChoseViewController: UIViewController {

    // URL 的数组
    var urls: [NSURL]
    // 用户当前选中的照片索引值
    var selectedIndex: Int
    init(url:[NSURL],index: Int) {
        self.urls = url
        self.selectedIndex = index
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func viewWillLayoutSubviews() {
//        var w = UIScreen.mainScreen().bounds
//        w.size.width += 20
//        view = UIView(frame: w)
//        
//        view.backgroundColor = UIColor.redColor()
//    }
    override func viewDidLoad() {
//        print(urls)
        super.viewDidLoad()
        var w = UIScreen.mainScreen().bounds
        w.size.width += 20
        view = UIView(frame: w)
        
        view.backgroundColor = UIColor.redColor()
        setUpUI()
        
    }
//    按钮监听方法
    func save() {
        //    获取照片
        let indexPath = collectionView.indexPathsForVisibleItems().last!
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhoneChoseCell
        guard let image = cell.phoneImageView.image else {
        return
        }
        
//        保存
        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
//    保存图片方法
   //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    func image(image: UIImage,didFinishSavingWithError error: NSError?,contextInfo: AnyObject) {
    print(image)
        let msg = (error == nil) ? "保存成功" : " 保存失败"
        SVProgressHUD.showInfoWithStatus(msg)
    
    }
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    // 提示：所有成熟的第三方框架中，只有sdwebimage支持gif播放！但是内存消耗非常大！
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 跳转到用户选中的照片
        let indexPath = NSIndexPath(forItem: selectedIndex, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
    }
    

    func setUpUI(){
//添加控件，
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
//        设置约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
       let dict = ["cv": collectionView,"save": saveButton,"close": closeButton]
        collectionView.frame = view.bounds
//    collectionView布局
        // 2> 关闭 & 保存按钮
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[save(32)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[close(32)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        // 提示：约束关系 =, >=, <=
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[close(100)]-(>=0)-[save(100)]-28-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
//     按钮监听方法
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
//设置 collectionView的属性
        setUpForcollectionView()
        
}
    func setUpForcollectionView() {
    collectionView.registerClass(PhoneChoseCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.dataSource = self
//        设置布局
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        // collectionView 的大小同样会宽 20 个点
        layout.itemSize = view.bounds.size
        print(collectionView)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView.pagingEnabled = true

    }
    
   //懒加载控件
    private lazy var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var closeButton: UIButton = UIButton(title: "关闭", fontSize: 14, color: UIColor.whiteColor(), backColor: UIColor.darkGrayColor())
    private lazy var saveButton: UIButton = UIButton(title: "保存", fontSize: 14, color: UIColor.whiteColor(), backColor: UIColor.darkGrayColor())


   
}
//  数据源方法
extension PhotoChoseViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell", forIndexPath: indexPath) as! PhoneChoseCell
        
        cell.backgroundColor = UIColor.grayColor()
        cell.imageURL = urls[indexPath.item]
//        print(urls)
        
        return cell
    }
}

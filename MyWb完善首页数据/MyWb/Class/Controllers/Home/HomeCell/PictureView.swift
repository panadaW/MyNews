//
//  PictureView.swift
//  MyWb
//
//  Created by 王明申 on 15/10/14.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit
//cell重用标识符
private let pictureID = "cell"
class PictureView: UICollectionView {
    var status: Status? {
        didSet {
//      需要重写sizeThatFits
        sizeToFit()
        reloadData()
        }
        }
    override func sizeThatFits(size: CGSize) -> CGSize {
        return sizeOfPicture()
    }
//    计算视图大小
    private func sizeOfPicture()-> CGSize {
//    设置单张图片默认大小
        let itemsize = CGSize(width: 90, height: 90)
//        设置每张图片间距
        let margin: CGFloat = 10
//        设置每行对都图片数量
        let countM = 3
    pictureLayout.itemSize = itemsize
//        根据图片数量计算视图大小
        let count = status?.pictureURLs?.count ?? 0
        if count == 0 {
        return CGSizeZero
        }
        if count == 1 {
        let size = CGSize(width: 150, height: 150)
            pictureLayout.itemSize = size
            return size
        }
        if count == 4 {
        let w = itemsize.width * 2 + margin
            return CGSize(width: w, height: w)
        }
//        计算行数
        let row = (count - 1) / countM + 1
        let w = itemsize.width * CGFloat(countM) + margin * CGFloat(countM - 1)
        let h = itemsize.height * CGFloat(row) + margin * CGFloat(row - 1)
        return CGSize(width: w, height: h)
    }
  //    设置流水布局
    let pictureLayout = UICollectionViewFlowLayout()
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: pictureLayout)
        backgroundColor = UIColor.lightGrayColor()
        registerClass(pictureCell.self, forCellWithReuseIdentifier: pictureID)
        self.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/// 给视图导入图片，添加分类
   extension PictureView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.pictureURLs?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(pictureID, forIndexPath: indexPath) as! pictureCell
        cell.imgurl = status?.pictureURLs![indexPath.row]
        return cell
    }
    
    
}
//自定义cell
class pictureCell: UICollectionViewCell {
//定义图片url属性
    var imgurl: NSURL? {
        didSet {
        iconView.sd_setImageWithURL(imgurl)
        
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    布局视图
   private func setUpUI() {
        //    添加控件
        contentView.addSubview(iconView)
        iconView.ff_Fill(contentView)
    }
    // 懒加载控件
    lazy var iconView: UIImageView = UIImageView()


}


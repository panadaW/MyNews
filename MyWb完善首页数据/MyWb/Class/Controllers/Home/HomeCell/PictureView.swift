//
//  PictureView.swift
//  MyWb
//
//  Created by 王明申 on 15/10/14.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//
import SDWebImage
import UIKit
//创建图片选择的通知
let MyPictureNotifitation = "MyPictureNotifitation"
//URL的key
let MyPictureUrlKey = "MyPictureUrlKey"
//indexpath的key
let MyPictureIndexPathKey = "MyPictureIndexPathKey"
//cell重用标识符
private let pictureID = "cell"
class PictureView: UICollectionView {
    var status: Status? {
        didSet {
//           print(status?.largePictureURLs)
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
            let key = status!.pictureURLs![0].absoluteString
//             获取缓存图片大小
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
        var size = CGSize(width: 150, height: 120)
            if image != nil {
               size = image.size
            }
            size.width = size.width < 40 ? 40 : size.width
            size.width = size.width > UIScreen.mainScreen().bounds.width ? 150 : size.width
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
        self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/// 给视图导入图片，添加分类
   extension PictureView: UICollectionViewDataSource,UICollectionViewDelegate {
//    选中单元格代理方法
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        print(status!.largePictureURLs!)
        NSNotificationCenter.defaultCenter().postNotificationName(MyPictureNotifitation,
            object: self,
            userInfo: [MyPictureUrlKey: status!.largePictureURLs!,
                MyPictureIndexPathKey: indexPath])
        
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.pictureURLs?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(pictureID, forIndexPath: indexPath) as! pictureCell
        cell.imgurl = status?.pictureURLs![indexPath.item]
        return cell
    }
    
    
}
//自定义cell
class pictureCell: UICollectionViewCell {
//定义图片url属性
    var imgurl: NSURL? {
        didSet {
        iconView.sd_setImageWithURL(imgurl)
            gifImageView.hidden = ((imgurl!.absoluteString as NSString).pathExtension.lowercaseString != "gif")
        
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
    iconView.addSubview(gifImageView)
        iconView.ff_Fill(contentView)
    gifImageView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: iconView, size: nil)
    }
    // 懒加载控件
    lazy var iconView: UIImageView = {
    
        let imageV = UIImageView()
        imageV.contentMode = UIViewContentMode.ScaleAspectFill
        imageV.clipsToBounds = true
        return imageV
    }()
//  懒加载GIF图标控件
    lazy var gifImageView: UIImageView = UIImageView(image: UIImage(named: "timeline_image_gif"), highlightedImage: nil)
}


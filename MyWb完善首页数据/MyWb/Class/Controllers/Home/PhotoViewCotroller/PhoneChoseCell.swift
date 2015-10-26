//
//  PhoneChoseCell.swift
//  MyWb
//
//  Created by 王明申 on 15/10/20.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit
import SDWebImage
class PhoneChoseCell: UICollectionViewCell {
    var imageURL:NSURL? {
        didSet {
            
            
            indicator.startAnimating()
//            重设布局
            resetphoneScrollView()
            self.phoneImageView.sd_setImageWithURL(self.imageURL) { (image, _, _, _) -> Void in
                self.indicator.stopAnimating()
                if self.phoneImageView.image == nil {
                    print("没有获取图像")
                    return
                }
//                加载图片
                self.setUpLocation()
               
            }
            
        }
    
    }
//    重新布局
    func resetphoneScrollView() {
//        重新设置图片的形变
        phoneImageView.transform = CGAffineTransformIdentity
        phoneScrollView.contentInset = UIEdgeInsetsZero
        phoneScrollView.contentOffset = CGPointZero
        phoneScrollView.contentSize = CGSizeZero
    }
//    设置图片位置
    func setUpLocation() {
        let s = self.setUpSizeOfPhoneImageview(phoneImageView.image!)
//    长微博
        if s.height < phoneScrollView.bounds.height {
//        让图片垂直居中
            let y = (phoneScrollView.bounds.height - s.height) * 0.5
            phoneImageView.frame = CGRect(origin: CGPointZero, size: s)
          phoneScrollView.contentInset = UIEdgeInsetsMake(y, 0, y, 0)
        } else {
        phoneImageView.frame = CGRect(origin: CGPointZero, size: s)
//          让图片超出范围可以滚动
            phoneScrollView.contentSize = s
        }
//    短微博
    }
//    设置图片尺寸
    func setUpSizeOfPhoneImageview(image: UIImage)->CGSize {
//    图像高宽比
        let scale = image.size.height / image.size.width
        let h = scale * phoneScrollView.bounds.width
        return CGSizeMake(phoneScrollView.bounds.width, h)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpUI() {
//    添加控件
        contentView.addSubview(phoneScrollView)
        phoneScrollView.addSubview(phoneImageView)
        contentView.addSubview(indicator)
//      phoneScrollView.backgroundColor = UIColor.redColor()
       
//        设置布局
        phoneScrollView.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[sv]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sv": phoneScrollView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[sv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sv": phoneScrollView]))
        
        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
//设置phoneScrollView的属性
        prepareForphoneScrollView()
        layoutIfNeeded()
    
    }
    private func prepareForphoneScrollView() {
//        设置代理
           phoneScrollView.delegate = self
//        设置缩放比例
        phoneScrollView.maximumZoomScale = 2.0
        phoneScrollView.minimumZoomScale = 0.5
    }
  
//懒记在scrollview控件
   lazy var phoneScrollView = UIScrollView()
   //    懒加载imageview控件
    lazy var phoneImageView = UIImageView()
//    懒加载网络加载图标
    lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
}
extension PhoneChoseCell: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return phoneImageView
    }
//    图片完成缩放后，让其居中显示
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
//      
        var offx = (phoneScrollView.bounds.width - view!.frame.width) * 0.5
        offx = offx > 0 ? offx : 0
        var offy = (phoneScrollView.bounds.height - view!.frame.height) * 0.5
        offy = offy > 0 ? offy : 0
        phoneScrollView.contentInset = UIEdgeInsets(top: offy, left: offx, bottom: 0, right: 0)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
}


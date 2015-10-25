//
//  PhotoCollectionViewController.swift
//  MyWb
//
//  Created by 王明申 on 15/10/25.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit

private let MyCell = "Cell"
private let maxcount = 9
class PhotoCollectionViewController: UICollectionViewController,PhotoSelectorViewCellDelegate {
//    照片数组
    lazy var photos: [UIImage] = [UIImage]()
//当前选中照片索引
    private var currentIndex = 0
//  注：  构造函数，必须要写
    init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
           }
    func prepareCollectionView() {
    collectionView?.backgroundColor = UIColor.orangeColor()
      let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    collectionView?.registerClass(PhotoSelectorViewCell.self, forCellWithReuseIdentifier: MyCell)
    }
   
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (photos.count == maxcount) ? photos.count : photos.count + 1
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MyCell, forIndexPath: indexPath) as! PhotoSelectorViewCell
    
        cell.backgroundColor = UIColor.redColor()
        cell.photoDelegate = self
        cell.image = (indexPath.item < photos.count) ? photos[indexPath.item] : nil
        return cell
    }
//实现协议方法
   private func photoSelectorViewCellSelectPhoto(cell: PhotoSelectorViewCell) {
    if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
    print("无法访问照片")
        return
    }
    let indexPath = collectionView?.indexPathForCell(cell)
    currentIndex = (indexPath?.item)!
//    实例化照片选择控制器
    let picker = UIImagePickerController()
//    监听选中的照片，需要使用代理
    picker.delegate = self
    presentViewController(picker, animated: true, completion: nil)
    }
   private func photoSelectorViewCellRemovePhoto(cell: PhotoSelectorViewCell) {
        let indexpath = collectionView?.indexPathForCell(cell)
        photos.removeAtIndex(indexpath!.item)
        collectionView?.reloadData()
    }
}
extension PhotoCollectionViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
//   监听选择照片的方法
     func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let img = image.scaleImage(300)
        if currentIndex == photos.count {
        photos.append(img)
        } else {
        photos[currentIndex] = img
        }
        collectionView?.reloadData()
       dismissViewControllerAnimated(true, completion: nil)
    }
}
//让控制器选择照片，又因为有明显的包含关系，使用代理
    //定义协议
private protocol PhotoSelectorViewCellDelegate: NSObjectProtocol {
//选择照片
    func photoSelectorViewCellSelectPhoto(cell: PhotoSelectorViewCell)
   // 删除照片
    func photoSelectorViewCellRemovePhoto(cell: PhotoSelectorViewCell)
    
}
//自定义cell
private class PhotoSelectorViewCell :UICollectionViewCell {
    var image: UIImage? {
        didSet {
            if image == nil {
            savephoto.setImage("compose_pic_add")
            } else {
            savephoto.setImage(image, forState: UIControlState.Normal)
            }
           removephoto.hidden = (image == nil)
        }
    
    }
    weak var photoDelegate: PhotoSelectorViewCellDelegate?
//    添加照片
   @objc func addphoto() {
    photoDelegate?.photoSelectorViewCellSelectPhoto(self)
    
    }
//    删除照片
   @objc func delate() {
    photoDelegate?.photoSelectorViewCellRemovePhoto(self)
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
        addSubview(savephoto)
        addSubview(removephoto)
//        设置布局
        savephoto.translatesAutoresizingMaskIntoConstraints = false
        removephoto.translatesAutoresizingMaskIntoConstraints = false
        let dict = ["save":savephoto,"remove":removephoto]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[save]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[save]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[remove]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[remove]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
//        添加添加监听方法
        savephoto.addTarget(self, action: "addphoto", forControlEvents: UIControlEvents.TouchUpInside)
        removephoto.addTarget(self, action: "delate", forControlEvents: UIControlEvents.TouchUpInside)
//        设置照片填充模式
        savephoto.imageView?.contentMode = UIViewContentMode.ScaleAspectFill

    }






//懒加载控件
    lazy var savephoto: UIButton = UIButton(imageName: "compose_pic_add")
    lazy var removephoto: UIButton = UIButton(imageName: "compose_photo_close")




}











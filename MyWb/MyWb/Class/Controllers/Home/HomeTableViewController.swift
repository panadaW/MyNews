//
//  HomeTableViewController.swift
//  MyWb
//
//  Created by 王明申 on 15/10/8.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    var statues: [Status]? {
        didSet{
        tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if TokenModel.loadToken == nil {
        visitorview?.changViewInfo(true, imagename: "visitordiscover_feed_image_smallicon", message: "关注一些人，回这里看看有什么惊喜")
        return
        }
        prepareFortableView()
        loadstatus()
    }

    // MARK:注册cell
    private func prepareFortableView() {
    tableView.registerClass(homeCell.self, forCellReuseIdentifier: "Wcell")
//       预估行高
//        tableView.estimatedRowHeight = 300
//        tableView.rowHeight = UITableViewAutomaticDimension
//        取消分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None

    }

    func loadstatus() {
        //加载用户数据
        Status.loadstatus { [weak self](dataList, error) -> () in
            if error != nil {
                print(error)
                return
            }
            self?.statues = dataList
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statues?.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Wcell", forIndexPath: indexPath) as! homeCell
        cell.status = statues![indexPath.row]
        tableView.rowHeight = 300
        return cell
    }
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("Wcell", forIndexPath: indexPath) as! homeCell
////        let ID = "Cell"
////        var cell = tableView.dequeueReusableCellWithIdentifier(ID)
////        if cell == nil{
////            cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ID)
////            }
//          cell.status = status![indexPath.row]
//        
//        
//        return cell
//    }
//
}

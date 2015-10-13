//
//  HomeTableViewController.swift
//  MyWb
//
//  Created by 王明申 on 15/10/8.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadstatus()
    }
    func loadstatus() {
        //加载用户数据
        NetWorkShare.shareTools.loadStatus { (resault, error) -> () in
            print(resault)
            
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}

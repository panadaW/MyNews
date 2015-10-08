//
//  BaseTableViewController.swift
//  MyWb
//
//  Created by 王明申 on 15/10/8.
//  Copyright © 2015年 晨曦的Mac. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    override func viewDidLoad() {
        let key = false
        key ? super.viewDidLoad() : pickview()
    }
    func pickview(){
    view = VisitorLoadView()
        view.backgroundColor = UIColor.whiteColor()
    
    }
    
   












}

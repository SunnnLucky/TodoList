//
//  TDLBaseTVController.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/9.
//

import UIKit

class TDLBaseTVController: UITableViewController {
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        TDLLog("当前控制器 ===>> \(NSStringFromClass(type(of: self)))")
    }
    
    override func didReceiveMemoryWarning() {
        TDLLog("内存警告 ===>> \(NSStringFromClass(type(of: self)))")
    }
    
    deinit {
        TDLLog("deinit ===>> \(NSStringFromClass(type(of: self)))")
    }
}

// MARK: - Table view data source
extension TDLBaseTVController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}

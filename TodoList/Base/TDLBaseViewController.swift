//
//  TDLBaseViewController.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/9.
//

import UIKit

class TDLBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        TDLLog(object_getClassName(self))
    }
    
    override func didReceiveMemoryWarning() {
        TDLLog("内存警告 =======>> \(object_getClassName(self))")
    }
    
    deinit {
        TDLLog("deinit =======>> \(object_getClassName(self))")
    }
}

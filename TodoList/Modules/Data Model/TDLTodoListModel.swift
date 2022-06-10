//
//  TDLTodoListModel.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/10.
//

import Foundation

class TDLTodoListModel {
    var text : String = ""
    var isSelect : Bool = false
    
    init(_ text : String , _ isSelect : Bool) {
        self.text = text
        self.isSelect = isSelect
    }
}

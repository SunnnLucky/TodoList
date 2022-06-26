//
//  Category.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/20.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colorHex: String = ""
    let items = List<Item>()
}

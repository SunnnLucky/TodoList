//
//  Item.swift
//  TodoList
//
//  Created by 孙磊 on 2022/6/20.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var done: Bool = false
    @objc dynamic var colorHex: String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

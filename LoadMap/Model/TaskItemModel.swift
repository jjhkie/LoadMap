//
//  TaskItemModel.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/10.
//

import Foundation
import RealmSwift

class TaskItem:Object{
    @objc dynamic var itemName: String = ""
    @objc dynamic var itemComplete : Bool = false
    @objc dynamic var itemCompleteDate : Date?
    @objc dynamic var dateOfCreation : Date?
    var tags = List<ItemTag>()
    var parentTask = LinkingObjects(fromType: Task.self, property: "items")
}

class ItemTag:Object{
    @objc dynamic var tagName: String?
    var parentItem = LinkingObjects(fromType: TaskItem.self, property: "tags")
}

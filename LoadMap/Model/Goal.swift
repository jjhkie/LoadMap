//
//  Home.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/17.
//

import Foundation
import RealmSwift

class Goal: Object{
    @objc dynamic var icon: String?
    @objc dynamic var title: String?
    @objc dynamic var startDay : Date = Date()
    @objc dynamic var endDay : Date = Date()
    @objc dynamic var expanded : Bool = false
    var items = List<GoalItem>()
}




class GoalItem:Object{
    @objc dynamic var itemName: String?
    @objc dynamic var itemComplete : Bool = false
}

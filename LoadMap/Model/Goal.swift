//
//  Home.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/17.
//

import Foundation
import RxDataSources

struct Goal{
    var header: GoalHeader
    var items: [GoalItem]
}



struct GoalHeader{
    var icon: String
    var title: String
    var startDay : Date
    var endDay : Date
    var expanded : Bool = false
}

struct GoalItem{
    var itemName: String
    var itemComplete : Bool
}

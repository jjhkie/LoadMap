//
//  Home.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/17.
//

import Foundation
import RealmSwift
import RxDataSources

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



//TableView 구현 데이터 타입
enum CellType:CaseIterable {
    case title
    case color
    case startDay
    case endDay
    case work
    
    var content: String{
        switch self{
            
        case .title:
            return " 제목"
        case .color:
            return "색상"
        case .startDay:
            return "시작 날짜"
        case .endDay:
            return "종료 날짜"
        case .work:
            return "업무"
        }
    }
}



// 2. Section 모델
struct TableCellData {
    var header: String
    var items: [CellType]
}

extension TableCellData: SectionModelType{
    init(original: TableCellData, items: [CellType]) {
        self = original
        self.items = items
    }
    
    
}

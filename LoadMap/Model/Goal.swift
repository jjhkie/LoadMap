//
//  Home.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/17.
//

import RealmSwift
import RxDataSources
import UIKit

class Goal: Object{
    @objc dynamic var icon: String?
    @objc dynamic var title: String?
    //@objc dynamic var boxColor : UIColor = UIColor.red
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
enum CellType{
    case title(emoji: String?, title: String?)
    case color(selecColor: UIColor)
    case setDay(selecDay: [Date?])
    case works(work: [String])
    

    var cellName: String?{
        switch self{
        case .title:
            return nil
        case .color:
            return "색상"
        case .setDay:
            return "기간"
        case .works:
            return "할일"
        }
    }
    
}

struct GoalCellData{
    var emojiAndTitle:[String]
    var color: UIColor
    var setDay: [Date]
    var setWork: [GoalItem?]
}



// 2. Section 모델
struct TableCellData {
    var header: String?
    var items: [CellType]
}

extension TableCellData: SectionModelType{
    init(original: TableCellData, items: [CellType]) {
        self = original
        self.items = items
    }
}

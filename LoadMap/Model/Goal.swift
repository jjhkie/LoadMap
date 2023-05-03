//
//  Home.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/17.
//

import RealmSwift
import RxDataSources
import UIKit

class Goal: Object,Identifiable{
    @objc dynamic var id = UUID().uuidString
    
    @objc dynamic var title: String = ""

    @objc dynamic var content: String = ""
    @objc dynamic var boxColor : GoalColor?
    @objc dynamic var creationDate : Date = Date()
    @objc dynamic var startDay : Date = Date()
    @objc dynamic var endDay : Date = Date()
    @objc dynamic var completion : Bool = false
    var items = List<GoalItem>()
}

class GoalColor:Object{
    @objc dynamic var red: Float = 0.0
    @objc dynamic var green: Float = 0.0
    @objc dynamic var blue: Float = 0.0
    @objc dynamic var alpha: Float = 1.0
    
    var uiColor: UIColor {
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
      }

    convenience init(red: CGFloat,green: CGFloat, blue: CGFloat, alpha: CGFloat) {
          self.init()
        self.red = Float(red)
        self.green = Float(green)
        self.blue = Float(blue)
        self.alpha = Float(alpha)
      }
}




class GoalItem:Object{
    @objc dynamic var itemName: String = ""
    @objc dynamic var itemComplete : Bool = false
}

//TableView 구현 데이터 타입
enum CellType{
    case title
    case color
    case setDay
    case works
    case task(message: String)
    

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
        case .task(message: _):
            return nil
        }
    }
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


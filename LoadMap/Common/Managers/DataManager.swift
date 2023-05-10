//
//  DataManager.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/30.
//


import RxRealm
import RealmSwift

class DataManager{
    
    static let shared = DataManager()
    
    private let realm = try! Realm()
    
    
    //데이터 가져오기
    func fetchData<T:Object>(type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    //데이터 저장하기
    func addData<T:Object>(object: T){
        try! realm.write{
            realm.add(object)
        }
    }
    
    func updateData<T:Object>(object: T, with dictionary: [String: Any?]) {
            try! realm.write {
                for (key, value) in dictionary {
                    if let value = value {
                        object.setValue(value, forKey: key)
                    }
                }
            }
        }
    
    //목표 아이템 수정하기
    func updateGoalItem(item: TaskItem, with dictionary: [String: Any?]) {
        try! realm.write {
            for (key, value) in dictionary {
                if let value = value {
                    switch key {
                    case "itemName":
                        item.itemName = value as! String
                    case "itemComplete":
                        item.itemComplete = value as! Bool
                    default:
                        break
                    }
                }
            }
        }
    }
}


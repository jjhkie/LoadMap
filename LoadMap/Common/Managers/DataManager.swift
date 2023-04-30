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
}

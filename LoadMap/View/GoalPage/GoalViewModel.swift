//
//  GoalViewModel.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/22.
//

import UIKit
import RxRealm
import RealmSwift
import RxCocoa
import RxSwift


class GoalViewModel{
    
    let bag = DisposeBag()
    
    let realm = try! Realm()
    
    lazy var objectData = realm.objects(Goal.self)
}


//MARK: - Basic
extension GoalViewModel:ViewModelBasic{
    
    struct Input {
        
    }
    
    struct Output {
        let cellData : Driver<[Goal]>
        
    }
    
    func inOut(input: Input) -> Output {
        
        
        
        let _cellData = Observable.array(from: objectData)
            .map{
                $0.isEmpty ? [Goal()] : $0
            }
        
        return Output(
            cellData:_cellData.asDriver(onErrorJustReturn: [])
        )
    }
    
    func updateDate(_ id: String){
        
        if let update = realm.objects(Goal.self).filter(NSPredicate(format: "id = %@", id)).first{
            try! realm.write{
                update.items.filter{
                    $0.itemComplete == false
                }.first?.itemComplete = true
            }
        }
    }
}



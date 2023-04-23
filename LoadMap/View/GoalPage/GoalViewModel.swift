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



protocol dataManage{
    func loadData()
}

class GoalViewModel{
    
    let bag = DisposeBag()
    
    let realm = try! Realm()
    
    var objectData : Results<Goal>?
    
    init(){
        loadData()
    }
}


//MARK: - Basic
extension GoalViewModel:ViewModelBasic{

    struct Input {
        
    }
    
    struct Output {
        let cellData : Driver<[Goal]>
        
    }
    
    func inOut(input: Input) -> Output {


        let cellArray = Observable.array(from: objectData!)

        return Output(
            cellData:cellArray
                .asDriver(onErrorJustReturn: [])
        )
    }
}

extension GoalViewModel:dataManage{
    func loadData() {
        self.objectData = realm.objects(Goal.self)
    }
}

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

}

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
}

extension GoalViewModel:dataManage{

}

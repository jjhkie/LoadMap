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
    
    var objectData: Results<Goal>{
        DataManager.shared.fetchData(type: Goal.self)
        .filter(NSPredicate(format: "completion == %d", false))
    }
   
    
    
    
}


//MARK: - Basic
extension GoalViewModel{
    
    struct Input {
        
    }
    
    struct Output {
        let cellData : Driver<[Goal]>
        
    }
    
    func inOut(input: Input) -> Output {
        
        
        
        
        let _cellData = Observable.collection(from: objectData)
            .map{
                Array($0)
            }

            
        
        return Output(
            cellData:_cellData.asDriver(onErrorJustReturn: [])
        )
    }
 
    
    
  
}

//MARK: - Function
extension GoalViewModel{
    
    func configureCell(_ cell: HomeItemCell, at index: Int) {
        cell.completeButtonTapped
            .subscribe(onNext: {
                let data = self.objectData[index]
                try! self.realm.write{
                    data.items.filter{
                        $0.itemComplete == false
                    }.first?.itemComplete = true
                    
                    if data.items.last?.itemComplete == true{
                        data.completion = true
                    }
                }
            })
            .disposed(by: cell.bag)
        
     
    }
    
    
    func updateDate(_ id: String){
        
        if let update = objectData.filter(NSPredicate(format: "id = %@", id)).first{
            try! realm.write{
                
                update.items.filter{
                    $0.itemComplete == false
                }.first?.itemComplete = true
                
                if update.items.last?.itemComplete == true{
                    update.completion = true
                }
            }
        }
    }
}

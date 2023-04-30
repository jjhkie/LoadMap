//
//  CalendarLineViewModel.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/26.
//

import RealmSwift
import RxRealm
import RxSwift
import RxCocoa
import Foundation

final class CalendarLineViewModel{
    
    private let realm = try! Realm()
    let dateObservable = BehaviorSubject(value: Date())
    
    var objectData: Results<Goal> = DataManager.shared.fetchData(type: Goal.self)
    
   
    
}

extension CalendarLineViewModel{

    
    struct Input{
        
    }
    
    struct Output{
        let cellData : Driver<[Goal]>
    }
    
    func inOut(input: Input) -> Output {
        
        let _cellData = dateObservable.flatMap { date -> Observable<[Goal]> in
            let filteredData = self.objectData.filter("startDay <= %@ AND endDay => %@", date, date)
            return Observable.array(from: filteredData)
        }
                
            
                

        
        return Output(cellData: _cellData.asDriver(onErrorJustReturn: []))
    }
}

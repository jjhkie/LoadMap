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
    
    let dateObservable = BehaviorSubject(value: Date())
    
    var objectData: Results<Note> = DataManager.shared.fetchData(type: Note.self)

}

extension CalendarLineViewModel{

    
    struct Input{
        
    }
    
    struct Output{
        let cellData : Observable<[Note]>
    }
    
    func inOut(input: Input) -> Output {
        
        let _cellData = dateObservable.flatMap { date -> Observable<[Note]> in
            let filteredData = self.objectData.filter(NSPredicate(format: "dateOfCreation >= %@ && dateOfCreation <= %@",date.startOfDay().koreanTime as NSDate, date.endOfDay().koreanTime as NSDate))
            return Observable.array(from: filteredData)
        }
                
            
                

        
        return Output(cellData: _cellData.asObservable())
    }
}


extension CalendarLineViewModel{
    
    func dotCount(_ date: Date) -> Int{
        return objectData.filter{
            $0.dateOfCreation.dayBefore().basicFormatter == date.basicFormatter
        }.count
    }
}

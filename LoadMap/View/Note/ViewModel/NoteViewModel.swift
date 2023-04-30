//
//  NoteViewModel.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/23.
//

import Foundation
import RealmSwift
import RxRealm
import RxCocoa
import RxSwift

class NoteViewModel{
 

    
    let bag = DisposeBag()

    let realm = try! Realm()
    
    var noteData : Results<Note>{
        DataManager.shared.fetchData(type: Note.self)
    }
    
    let selectedDate = BehaviorSubject(value: Date())
}


extension NoteViewModel{

    
    struct Input {
        
    }
    
    struct Output {
        let cellData: Driver<[Note]>
    }
    
    func inOut(input: Input) -> Output {
        
        
        
        let _cellData = selectedDate
            .flatMap{value -> Observable<[Results<Note>.ElementType]> in
                
                let predicate = NSPredicate(format: "noteDate == %@",value.dayStringText)
                let filterData = self.noteData.filter(predicate)
                return Observable.array(from: filterData)
            }
        

        return Output(cellData: _cellData.asDriver(onErrorJustReturn: []))
    }
}

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
    
    private let formmater = DateFormatter().then{
        $0.dateFormat = "yyyy-MM-dd"
    }
    let realm = try! Realm()
    
    lazy var noteData : Results<Note>? = realm.objects(Note.self)
    
    let selectedDate = BehaviorSubject(value: Date())
}


extension NoteViewModel:ViewModelBasic{

    
    struct Input {
        
    }
    
    struct Output {
        let cellData: Driver<[Note]>
    }
    
    func inOut(input: Input) -> Output {
        
        
        
        let cellData = selectedDate
            .flatMap{value -> Observable<[Results<Note>.ElementType]> in
                let formatDate = self.formmater.string(from: value)
                let predicate = NSPredicate(format: "noteDate == %@",formatDate)
                let filterData = self.noteData?.filter(predicate)
                return Observable.array(from: filterData!)
            }
        

        return Output(cellData: cellData.asDriver(onErrorJustReturn: []))
    }
}

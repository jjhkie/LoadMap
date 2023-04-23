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
    let realm = try! Realm()
    
    var noteData : Results<Note>?
    
    init(){
        loadData()
    }
}


extension NoteViewModel:ViewModelBasic{

    
    struct Input {
        
    }
    
    struct Output {
        let cellData: Driver<[Note]>
    }
    
    func inOut(input: Input) -> Output {
        
        let cellArray = Observable.array(from: noteData!)
        
        return Output(cellData: cellArray.asDriver(onErrorJustReturn: []))
    }
}

extension NoteViewModel{
    func loadData() {
        self.noteData = realm.objects(Note.self)
    }
}

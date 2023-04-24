//
//  NoteAddViewModel.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/23.
//


import RealmSwift
import RxSwift
import RxCocoa
import Foundation

class NoteAddViewModel{
    
    let bag = DisposeBag()
    let realm = try! Realm()
    
    var noteText = BehaviorSubject(value: "")
    
    let _noteSaved = PublishSubject<Void>()
}

extension NoteAddViewModel:ViewModelBasic{

    
    struct Input{
        let addButtonTapped: Observable<Void>
        
    }
    
    struct Output{
        let noteSaved : Signal<Void>
    }
    
    func inOut(input: Input) -> Output {
        
        input.addButtonTapped
            .subscribe(onNext: {
                self.addNote()
            })
            .disposed(by: bag)
        
        
        return Output(noteSaved: _noteSaved.asSignal(onErrorJustReturn: Void()))
    }
}


extension NoteAddViewModel{
    func addNote(){
        try! realm.write{
            let newNote = Note()
            newNote.noteDate = Date()
            newNote.noteContent = try! noteText.value()
            realm.add(newNote)
        }
        _noteSaved.onNext(Void())
    }
}

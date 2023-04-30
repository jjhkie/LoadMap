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
    
    var noteDate: String
    
    init(noteDate: String) {
        self.noteDate = noteDate
    }
    
    let formatter = DateFormatter()
    
    let bag = DisposeBag()
    let realm = try! Realm()
    
    var noteText = BehaviorSubject(value: "")
    
    let _noteSaved = PublishSubject<Void>()
}

extension NoteAddViewModel{
    
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
                self._noteSaved.onNext(Void())
            })
            .disposed(by: bag)
        
        
        return Output(noteSaved: _noteSaved.asSignal(onErrorJustReturn: Void()))
    }
}


extension NoteAddViewModel{
    func addNote(){
        
        let newNote = Note()
        newNote.noteDate = noteDate
        newNote.noteContent = try! noteText.value()
        
        DataManager.shared.addData(object: newNote)
        
    }
}

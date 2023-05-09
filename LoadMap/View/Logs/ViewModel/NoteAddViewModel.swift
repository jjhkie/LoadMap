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
    
    let noteText = BehaviorSubject(value: "")
    
    let _noteImportant = BehaviorSubject<String>(value:"low")
    
    let _noteDate = PublishSubject<Date>()
    
    let _noteSaved = PublishSubject<Void>()
}

extension NoteAddViewModel{
    
    struct Input{
       
    }
    
    struct Output{
        let noteSaved : Signal<Void>
    }
    
    func inOut(input: Input) -> Output {
        

        
        
        return Output(noteSaved: _noteSaved.asSignal(onErrorJustReturn: Void()))
    }
}


extension NoteAddViewModel{
    func addNote(date: Date){
        let newNote = Note()
        newNote.noteDate = date.koreanTime
        newNote.important = try! _noteImportant.value()
        newNote.noteContent = try! noteText.value()
        
        DataManager.shared.addData(object: newNote)
        _noteSaved.onNext(Void())
    }
    
    func importantTap(_ value: String){
        _noteImportant.onNext(value)
        
        
    }
}

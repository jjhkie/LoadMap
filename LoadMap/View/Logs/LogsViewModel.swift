//
//  LogsViewModel.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/09.
//

import Foundation
import RxCocoa
import RxSwift
import RealmSwift


final class LogsViewModel{
    
    
    private let datas = BehaviorRelay<[LogCustomData]>(value:[
        .sectionDates(title: nil, items: [.dateItems(date: Date())]),
        .sectionLogs(title: nil, items: [
            .LogItems(type: .goal, title: "목표입니다.", time: Date()),
            .LogItems(type: .tag, title: "Tag입니다.", time: Date()),
            .LogItems(type: .task, title: "업무입니다.", time: Date()),
            .LogItems(type: .task, title: "업무입니다.", time: Date()),
            .LogItems(type: .task, title: "업무입니다.", time: Date()),
            .LogItems(type: .task, title: "업무입니다.", time: Date()),
            .LogItems(type: .task, title: "업무입니다.", time: Date()),
            .LogItems(type: .task, title: "업무입니다.", time: Date()),
            .LogItems(type: .task, title: "업무입니다.", time: Date())
        ])
    ])
    
    private let selectedDate = BehaviorSubject(value: Date())
    
    
    var noteData : Results<Note>{
        DataManager.shared.fetchData(type: Note.self)
    }
    
    var taskData : Results<Task>{
        DataManager.shared.fetchData(type: Task.self)
    }
    
    var itemData : Results<TaskItem>{
        DataManager.shared.fetchData(type: TaskItem.self)
    }
    
    var tagData : Results<ItemTag>{
        DataManager.shared.fetchData(type: ItemTag.self)
    }
    var dateValues: [Date] {
        return noteData.map { $0.dateOfCreation }
    }
    
}

extension LogsViewModel{
    struct Input{
        
    }
    
    struct Output{
        let cellData : Driver<[LogCustomData]>
    }
    
    func inOut(input:Input) -> Output{
        
        //날짜 정보만 저장

        
        let _cellData = datas.asObservable()
        
        return Output(cellData: _cellData.asDriver(onErrorJustReturn: [])
        )
    }
}

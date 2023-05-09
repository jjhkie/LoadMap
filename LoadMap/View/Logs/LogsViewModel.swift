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
    
    
    var noteData : Results<Note>{
        DataManager.shared.fetchData(type: Note.self)
    }
    
    var taskData : Results<Goal>{
        DataManager.shared.fetchData(type: Goal.self)
    }
    
    var itemData : Results<GoalItem>{
        DataManager.shared.fetchData(type: GoalItem.self)
    }
    
    var tagData : Results<ItemTag>{
        DataManager.shared.fetchData(type: ItemTag.self)
    }
    var dateValues: [Date] {
        return noteData.map { $0.noteDate }
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

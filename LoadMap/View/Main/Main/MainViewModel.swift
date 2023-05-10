//
//  GoalViewModel.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/22.
//

import UIKit
import RxRealm
import RealmSwift
import RxCocoa
import RxSwift
import RxDataSources

//TODO
/// task note 데이터 작성 날짜가 오늘인 데이터만 가져오기 
final class MainViewModel{
    
    private let bag = DisposeBag()
    
    var taskData: Results<Task>{
        DataManager.shared.fetchData(type: Task.self)
            .filter(NSPredicate(format: "completion == %d", false))
    }
    
    var noteData: Results<Note>{
        DataManager.shared.fetchData(type: Note.self)
        
    }
    
    //작성 버튼 이벤트
    let _prepareTask = PublishSubject<Void>()
    let _prepareNote = PublishSubject<Void>()
    
    //task Detail 버튼 이벤트
    let _detailTapped = PublishSubject<Task.ID>()
    
    //taskItem Count
    var taskDataCount: Int{
        return taskData.count
    }
    
    //noteItem Count
    var noteDataCount: Int{
        return noteData.count
    }
    
}


//MARK: - Basic
extension MainViewModel{
    
    struct Input {
        
    }
    
    struct Output {
        //let cellData : Driver<[SectionModel<Bool, Goal>]>
        //let cellData : Driver<[MainSection]>
        let cellData : Driver<[MainModel]>
        let taskSignal : Signal<Void>
        let noteSignal : Signal<Void>
        let detailSignal : Signal<Task.ID>
        
    }
    
    func inOut(input: Input) -> Output {
        
        
        let _taskArr = Observable.array(from: taskData)
            .startWith()
        
        let _noteArr = Observable.array(from: noteData)
        
        
        
        let _cellData = Observable.combineLatest(_taskArr, _noteArr).map{tasks,notes in
            [
                MainModel.tasks(title: "task", items: tasks.map{.tasksItem($0)}),
                MainModel.notes(title: "note", items: notes.map{.notesItem($0)})
                
            ]
        }
        
        
        //        let _cellData = Observable.collection(from: objectData)
        //            .map{
        //                let processSectionItem = $0.filter("startDay >= %@",Date().koreanTime.startOfDay()).toArray()
        //                let scheduledtoSectionItem = $0.filter("startDay < %@",Date()).toArray()
        //                return [SectionModel(model: true, items: processSectionItem),
        //                        SectionModel(model: false, items: scheduledtoSectionItem)]
        //            }
        
        //let _cellData = dataSource.asObservable()
        
        
        
        return Output(
            cellData:_cellData.asDriver(onErrorJustReturn: []),
            taskSignal: _prepareTask.asSignal(onErrorJustReturn: Void()),
            noteSignal: _prepareNote.asSignal(onErrorJustReturn: Void()),
            detailSignal: _detailTapped.asSignal(onErrorJustReturn: "")
        )
    }
    
    
    
    
}

//MARK: - Function
extension MainViewModel{
    
    func itemIdToss(_ id: Task.ID){
        self._detailTapped.onNext(id)
    }
    
    func nextButtonConfigure(_ id: Task.ID){
        print("실행")
        if let data = DataManager.shared.fetchData(type: Task.self).filter(NSPredicate(format: "id = %@", id)).first{
            if let item =  data.items.filter(NSPredicate(format: "itemComplete = %d", false)).first{
                
                DataManager.shared.updateGoalItem(item:item , with: ["itemComplete" : true])
                
                if data.items.filter(NSPredicate(format: "itemComplete = %d", false)).count == 0{
                    DataManager.shared.updateData(object: data, with: ["completion":true])
                    print("완료했습니다.")
                }
            }else{
                print("해당 아이템이 없습니다.")
            }
           
        }else{
            print("그 id의 값은 없습니다.")
        }
    }
 
    

    
    
}


enum MainItem{
    case tasksItem(Task)
    case notesItem(Note)
}

enum MainModel{
    case tasks(title: String, items: [Item])
    case notes(title: String, items: [Item])
}

extension MainModel:SectionModelType{
    
    typealias Item = MainItem
    
    init(original: MainModel, items: [Item]) {
        switch original{
        case .tasks(title: let title, items: _):
            self = .tasks(title: title, items: items)
        case .notes(title: let title, items: _):
            self = .notes(title: title, items: items)
        }
    }
    
    var items: [MainItem] {
        switch self{
            
        case .tasks(title: _, items: let items):
            return items.map{$0}
        case .notes(title: _, items: let items):
            return items.map{$0}
        }
    }
    
    var title: String{
        switch self{
            
        case .tasks(title: let title, items: _):
            return title
        case .notes(title: let title, items: _):
            return title
        }
    }
}

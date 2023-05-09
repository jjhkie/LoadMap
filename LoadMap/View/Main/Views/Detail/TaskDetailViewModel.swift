//
//  TaskDetailViewModel.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/05.
//

import Foundation
import RealmSwift
import RxDataSources
import RxSwift
import RxCocoa
import RxRealm


final class TaskDetailViewModel{
    private let id : Goal.ID
    
    init(id: Goal.ID) {
        self.id = id
    }
    
    var selectedTask: Results<Goal>{
        DataManager.shared.fetchData(type: Goal.self)
            .filter(NSPredicate(format: "id == %@", id))
    }
    
}

extension TaskDetailViewModel{
    struct Input{
        
    }
    
    struct Output{
    }
    
    func inOut(input: Input) -> Output{
        var selectedItems: Results<GoalItem>? {
            return selectedTask.first?.items.sorted(byKeyPath: "abc")
        }

        
        return Output(
            
        )
    }
}




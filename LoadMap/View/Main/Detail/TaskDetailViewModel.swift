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
    private let id : Task.ID
    
    init(id: Task.ID) {
        self.id = id
    }
    
    var selectedTask: Results<Task>{
        DataManager.shared.fetchData(type: Task.self)
            .filter(NSPredicate(format: "id == %@", id))
    }
    
}

extension TaskDetailViewModel{
    struct Input{
        
    }
    
    struct Output{
    }
    
    func inOut(input: Input) -> Output{

        
        return Output(
            
        )
    }
}




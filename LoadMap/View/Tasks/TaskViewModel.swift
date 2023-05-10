//
//  TaskViewModel.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/10.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift
import RxCocoa

class TaskViewModel{
    
    var taskData: Results<Task>{
        DataManager.shared.fetchData(type: Task.self)
    }
    
    let defaultTask = Task() //
    
}

extension TaskViewModel{
    struct Input{
        
    }
    
    struct OutPut {
        let cellData: Observable<[Task]>
        
    }
    
    func inOut(input: Input) -> OutPut{
        
       
        
        let _cellData = Observable.array(from: taskData)

        
        return OutPut(
            cellData: _cellData.asObservable()
        )
    }
}

//
//  CalendarLineViewModel.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/26.
//

import RealmSwift

final class CalendarLineViewModel{
    
    private let realm = try! Realm()
    
}

extension CalendarLineViewModel:ViewModelBasic{

    
    struct Input{
        
    }
    
    struct Output{
        
    }
    
    func inOut(input: Input) -> Output {
        return Output()
    }
}

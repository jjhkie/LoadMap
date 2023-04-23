//
//  NoteAddViewModel.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/23.
//

import Foundation
import RealmSwift
import RxSwift

class NoteAddViewModel{
    
    let bag = DisposeBag()
    let realm = try! Realm()
}

extension NoteAddViewModel:ViewModelBasic{

    
    struct Input{
        let addButtonTapped: Observable<Void>
        
    }
    
    struct Output{
        
    }
    
    func inOut(input: Input) -> Output {
        
        input.addButtonTapped
            .subscribe(onNext: {
                print("abc")
            })
            .disposed(by: bag)
        return Output()
    }
}

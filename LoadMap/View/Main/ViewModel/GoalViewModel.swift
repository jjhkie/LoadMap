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


final class GoalViewModel{
    
    let bag = DisposeBag()
    
    var objectData: Results<Goal>{
        DataManager.shared.fetchData(type: Goal.self)
            .filter(NSPredicate(format: "completion == %d", false))
    }
    
    let expandedSections = BehaviorRelay<[Bool]>(value: [true, true])
    
    
    
}


//MARK: - Basic
extension GoalViewModel{
    
    struct Input {
        
    }
    
    struct Output {
        let cellData : Driver<[SectionModel<Bool, Goal>]>
        
    }
    
    func inOut(input: Input) -> Output {
        
        
        
        
        let _cellData = Observable.collection(from: objectData)
            .map{
                let processSectionItem = $0.filter("startDay >= %@",Date().koreanTime.startOfDay()).toArray()
                let scheduledtoSectionItem = $0.filter("startDay < %@",Date()).toArray()
                return [SectionModel(model: true, items: processSectionItem),
                        SectionModel(model: false, items: scheduledtoSectionItem)]
            }
        
        
        return Output(
            cellData:_cellData.asDriver(onErrorJustReturn: [])
        )
    }
    
    
    
    
}

//MARK: - Function
extension GoalViewModel{
    
    //버튼 눌렀을 때 업부에 대한 아이템 완료로 바꾸기
    func configureCell(_ cell: HomeItemCell, at index: Int) {
        cell.completeButtonTapped
            .subscribe(onNext: {
                let data = self.objectData[index]
                //                try! self.realm.write{
                //                    data.items.filter{
                //                        $0.itemComplete == false
                //                    }.first?.itemComplete = true
                //
                //                    if data.items.last?.itemComplete == true{
                //                        data.completion = true
                //                    }
                //                }
            })
            .disposed(by: cell.bag)
    }
    func tableDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<Bool, Goal>>{
        return  RxTableViewSectionedReloadDataSource<SectionModel<Bool, Goal>>(configureCell:{(dataSource,tableView,indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "goalItemCell", for: indexPath) as! HomeItemCell
            
            let isExpanded = self.expandedSections.value[indexPath.section]
            cell.contentView.isHidden = !isExpanded
            cell.setData(item)
            //cell.textLabel?.text = item.title
            return cell
        },titleForHeaderInSection: { dataSource, index in
            if dataSource[index].model == true{
                return "현재 진행 중인 업무 \(dataSource[index].items.count)"
            }else{
                return "진행 예정 업무 \(dataSource[index].items.count)"
            }
        })
    }
    
}

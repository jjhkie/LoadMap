//
//  GoalAddViewModel.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/21.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import RxDataSources

protocol GoalAddPro{
    //테이블 뷰 DataSource
    func tableViewDataSource() ->RxTableViewSectionedReloadDataSource<TableCellData>
}

class GoalAddViewModel{
    
    let bag = DisposeBag()
    
    private var realm = try! Realm()
    
    let cellData = BehaviorRelay<[TableCellData]>(value:[TableCellData(items: [
        .title,
        .color,
        .setDay,
        .works
    ])])
    
    let emojiText = BehaviorSubject<String>(value: "")
    let titleText = BehaviorSubject<String>(value:"")
    let selectedColor = BehaviorSubject<GoalColor>(value: GoalColor())
    
    let _startDate = BehaviorSubject<Date>(value: Date())
    let _endDate = BehaviorSubject<Date>(value: Date())
    
    //var worksData = PublishSubject<[String]>()
    var worksData = BehaviorRelay<[String]>(value: [])
    
    let _addPageModal = PublishSubject<Void>()

}

//MARK: - Input Output
extension GoalAddViewModel{
    
    struct Input{
        
    }
    
    struct Output{
        let tableData : Driver<[TableCellData]>
        let addPageModal : Signal<Void>
    }
    
    func inOut(input: Input) -> Output{

        
        
        
        return Output(
            tableData: self.cellData.asDriver(onErrorJustReturn: []),
            addPageModal: _addPageModal.asSignal(onErrorJustReturn: Void())
        )
    }
    


}

//MARK: - Function
extension GoalAddViewModel:GoalAddPro{
    
    
    func dataSave(){
        let data = Goal()
        
        data.icon = try! emojiText.value()
        data.title = try! titleText.value()
        data.boxColor = try! selectedColor.value()
        data.startDay = try! _startDate.value().startOfDay().koreanTime
        data.endDay = try! _endDate.value().endOfDay().koreanTime
        
        for value in worksData.value{
            let item = GoalItem()
            item.itemName = value
            data.items.append(item)
        }
        
        DataManager.shared.addData(object: data)
    }
    
    
    func tableViewDataSource() -> RxTableViewSectionedReloadDataSource<TableCellData> {
        return RxTableViewSectionedReloadDataSource<TableCellData>(
            configureCell: { dataSource, tableView, indexPath, item in
 
                switch item{
                case .title:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as? GoalAddMainCell else {return UITableViewCell()}
          
                    cell.bind(self)
                    
                    return cell
                case .color:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") as? GoalColorCell else {return UITableViewCell()}
                    
                    cell.bind(self)
                        
                    return cell
                case .setDay:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as? GoalDateCell else {return UITableViewCell()}
                    cell.bind(self)
                    return cell
                case .works:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? GoalItemCell else {return UITableViewCell()}
                    
             
                    cell.bind(self)

                    
                    return cell
                }
                
            }
            
        )
    }
    
    
}

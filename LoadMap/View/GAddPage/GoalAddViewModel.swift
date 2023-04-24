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
        .title(emoji: nil, title: nil),
        .color(selecColor: UIColor.white),
        .setDay(selecDay: []),
        .works(work: [])
    ])])
    
    let emojiText = BehaviorSubject<String>(value: "")
    let titleText = BehaviorSubject<String>(value:"")
    let selectedColor = BehaviorSubject<GoalColor>(value: GoalColor())
    
    let worksData = BehaviorSubject<[String]>(value:[])
    var workArr: [String] = []
    
    func workAdd(_ data: [String]){
        worksData.onNext(data)
    }
}

//MARK: - Input Output
extension GoalAddViewModel:ViewModelBasic{
    
    struct Input{
        
    }
    
    struct Output{
        let tableData : Driver<[TableCellData]>
    }
    
    func inOut(input: Input) -> Output{

        
        
        
        return Output(
            tableData: self.cellData.asDriver(onErrorJustReturn: [])
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
        for value in try! worksData.value(){
            let item = GoalItem()
            item.itemName = value
            data.items.append(item)
        }
       
        try! self.realm.write{
            self.realm.add(data)
        }
    }
    
    
    func tableViewDataSource() -> RxTableViewSectionedReloadDataSource<TableCellData> {
        return RxTableViewSectionedReloadDataSource<TableCellData>(
            configureCell: { dataSource, tableView, indexPath, item in
                print(indexPath)
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
                    //cell.selectionStyle = .none
                    
                    return cell
                case .works:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? GoalItemCell else {return UITableViewCell()}
                    cell.titleLabel.text = item.cellName
                    cell.selectionStyle = .none
                    cell.bind(self)
                    cell.addButton.setTitle("Click", for: .normal)
                    
                    //cell.addButton.addTarget(self, action: #selector(addView), for: .touchDown)
                    
                    return cell
                }
                
            }
            
        )
    }
    
    
}

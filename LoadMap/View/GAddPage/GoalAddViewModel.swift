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
    
    let cellData = BehaviorRelay<[TableCellData]>(value:[])
    
    let emojiText = BehaviorSubject<String>(value: "")
    let titleText = BehaviorSubject<String>(value:"")
    
    
}

//MARK: - Input Output
extension GoalAddViewModel{
    
    struct Input{
        
    }
    
    struct Output{
        let tableData : Driver<[TableCellData]>
        let testData : Observable<String>
        
    }
    
    func inOut(input: Input) -> Output{
        
        cellData.accept([TableCellData(header: "", items: [.title,.color,.startDay,.endDay,.work])])
        return Output(
            tableData: self.cellData.asDriver(onErrorJustReturn: []),
            testData: self.emojiText.asObservable()
        )
    }
}

//MARK: - Function
extension GoalAddViewModel:GoalAddPro{
    func tableViewDataSource() -> RxTableViewSectionedReloadDataSource<TableCellData> {
        return RxTableViewSectionedReloadDataSource<TableCellData>(
            configureCell: { [weak self] dataSource, tableView, indexPath, item in
                switch item{
                    
                case .title:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as? GoalAddMainCell else {return UITableViewCell()}
                    
                    cell.selectionStyle = .none
                    
                    
                    return cell
                case .color:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") as? GoalColorCell else {return UITableViewCell()}
                    cell.titleLabel.text = item.content
                    cell.selectionStyle = .none
                    
                    return cell
                case .startDay:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as? GoalDateCell else {return UITableViewCell()}
                    //cell.selectionStyle = .none
                    cell.titleLabel.text = item.content
                    return cell
                case .endDay:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as? GoalDateCell else {return UITableViewCell()}
                    cell.selectionStyle = .none
                    cell.titleLabel.text = item.content
                    cell.dateLabel.text = "\(Date())"
                    return cell
                case .work:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? GoalItemCell else {return UITableViewCell()}
                    cell.titleLabel.text = item.content
                    cell.selectionStyle = .none
                    //cell.contentTextView.delegate = self
                    //cell.contentTextView.tag = 3
                    cell.addButton.setTitle("Click", for: .normal)
                    //cell.addButton.addTarget(self, action: #selector(addView), for: .touchDown)
                    
                    return cell
                }
                
            }
            
        )
    }
    
    
}

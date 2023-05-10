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

protocol DataFunc{
    func titleOnNext(_ value: String) // title Data 관리
    func descriptionOnNext(_ value: String)
    func startDateOnNext(_ value: Date)
    func endDateOnNext(_ value: Date)
}

final class TaskAddViewModel{
    
    private let bag = DisposeBag()
    
    private let cellData = BehaviorRelay<[TableCellData]>(value:[TableCellData(items: [
        .title,
        .color,
        .setDay,
        .works
    ])])
    
    private let _titleText = BehaviorSubject<String>(value:"")
    
    private let _descriptionText = BehaviorSubject<String>(value: "")
 
    let _selectedColor = BehaviorSubject<TaskColor>(value: TaskColor())
    
    let _startDate = BehaviorSubject<Date>(value: Date())
    let _endDate = BehaviorSubject<Date>(value: Date())
    
    
    let _emptyAlert = PublishSubject<String>()
    
    let _successAdd = PublishSubject<Void>()
    
    let _dateButton = BehaviorSubject<Bool>(value: true)
    
}

//MARK: - data Function
extension TaskAddViewModel:DataFunc{

    func titleOnNext(_ value: String){
        _titleText.onNext(value)
    }
    
    func descriptionOnNext(_ value: String) {
        _descriptionText.onNext(value)
    }
    
    func startDateOnNext(_ value: Date){
        _startDate.onNext(value)
    }
    func endDateOnNext(_ value: Date) {
        _endDate.onNext(value)
    }
    
    func dateButtonOnNext(_ value: Bool){
        _dateButton.onNext(value)
    }
}

//MARK: - Input Output
extension TaskAddViewModel{
    
    struct Input{
        
    }
    
    struct Output{
        let tableData : Driver<[TableCellData]>
        let emptyAlert : Signal<String>
        let successAdd : Signal<Void>
    }
    
    func inOut(input: Input) -> Output{
        
        let _cellData = self.cellData.asObservable()
        
        
        return Output(
            tableData: _cellData.asDriver(onErrorJustReturn: []),
            emptyAlert: _emptyAlert.asSignal(onErrorJustReturn:""),
            successAdd: _successAdd.asSignal(onErrorJustReturn: Void())
        )
    }
    
    
    
}

//MARK: - Function
extension TaskAddViewModel:GoalAddPro{
    
    
    func dataSave(){
        var alertString = ""
        let titleIsValue = try! _titleText.value()
        let descriptionIsValue = try! _descriptionText.value()
        let workIsValue =  cellData.value.flatMap { $0.items.compactMap { item in
            if case let .task(message) = item {
                return  message.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            return nil
        }}
        
        if titleIsValue.isEmpty{
            alertString.append("제목")
        }
        
        if descriptionIsValue.isEmpty{
            if !alertString.isEmpty{
                alertString.append(",")
            }
            alertString.append("설명")
        }
        
        if workIsValue.isEmpty{
            if !alertString.isEmpty{
                alertString.append(",")
            }
            alertString.append("업무")
        }
        
        if alertString != ""{
            _emptyAlert.onNext(alertString)
        }else{
            let data = Task()
            data.content = try! _descriptionText.value()
            data.title = try! _titleText.value()
            data.boxColor = try! _selectedColor.value()
            data.startDay = try! _startDate.value().startOfDay().koreanTime
            data.endDay = try! _endDate.value().endOfDay().koreanTime
            
            for value in workIsValue{
                let item = TaskItem()
                item.itemName = value
                data.items.append(item)
            }
            DataManager.shared.addData(object: data)
            _successAdd.onNext(Void())
        }
        
    }
    
    
    func tableViewDataSource() -> RxTableViewSectionedReloadDataSource<TableCellData> {
        return RxTableViewSectionedReloadDataSource<TableCellData>(
            configureCell: { dataSource, tableView, indexPath, item in
                
                switch item{
                case .title:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as? TaskAddMainCell else {return UITableViewCell()}
                   
                    cell.bind(viewmodel: self)
                    
                    return cell
                case .color:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") as? TaskColorCell else {return UITableViewCell()}
                    
                    cell.bind(viewmodel: self)
                    
                    return cell
                case .setDay:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as? TaskDateCell else {return UITableViewCell()}

                    
                    cell.bind(viewmodel: self)
                    
                    return cell
                case .works:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? TaskItemCell else {return UITableViewCell()}
                    
                    cell.workTextView.rx.didChange
                        .bind(onNext:{
                            let textView = cell.workTextView
                            if let text = textView.text{
                                if text.hasSuffix("\n"){
                                    let currentValue = self.cellData.value[0].items
                                    let newValue = TableCellData(items: currentValue + [.task(message: text)])
 
                                    self.cellData.accept([newValue])
                                    
                                }
                            }
                            
                            cell.scrollBottom()
                            
                        })
                        .disposed(by: cell.bag)
                    
                    cell.bind(viewmodel: self)
                    
                    
                    return cell
                case .task(message: let message):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? ItemCell else {return UITableViewCell()}
  
  
                    cell.taskLabel.text = message
                    return cell
                }
                
            }
            
        )
    }
    
    
}

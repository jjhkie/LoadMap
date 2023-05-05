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

//TODO
/// task note 데이터 작성 날짜가 오늘인 데이터만 가져오기 
final class MainViewModel{
    
    let bag = DisposeBag()
    
    var taskData: Results<Goal>{
        DataManager.shared.fetchData(type: Goal.self)
            .filter(NSPredicate(format: "completion == %d", false))
    }
    
    var noteData: Results<Note>{
        DataManager.shared.fetchData(type: Note.self)
        
    }
    
    //작성 버튼 이벤트
    let _prepareTask = PublishSubject<Void>()
    let _prepareNote = PublishSubject<Void>()
    
    let expandedSections = BehaviorRelay<[Bool]>(value: [true, true])//remove
    
    
}


//MARK: - Basic
extension MainViewModel{
    
    struct Input {
        
    }
    
    struct Output {
        //let cellData : Driver<[SectionModel<Bool, Goal>]>
        //let cellData : Driver<[MainSection]>
        let cellData : Driver<[MainModel]>
        let taskSignal : Signal<Void>
        let noteSignal : Signal<Void>
        
    }
    
    func inOut(input: Input) -> Output {
        
        
        let _taskArr = Observable.array(from: taskData)
        
        let _noteArr = Observable.array(from: noteData)
        
        
        
        let _cellData = Observable.combineLatest(_taskArr, _noteArr).map{tasks,notes in
            [
                MainModel.tasks(title: "task", items: tasks.map{.tasksItem(value: $0)}),
                MainModel.notes(title: "note", items: notes.map{.notesItem(value: $0)})
                
            ]
            
            
            
        }
        
        
        //        let _cellData = Observable.collection(from: objectData)
        //            .map{
        //                let processSectionItem = $0.filter("startDay >= %@",Date().koreanTime.startOfDay()).toArray()
        //                let scheduledtoSectionItem = $0.filter("startDay < %@",Date()).toArray()
        //                return [SectionModel(model: true, items: processSectionItem),
        //                        SectionModel(model: false, items: scheduledtoSectionItem)]
        //            }
        
        //let _cellData = dataSource.asObservable()
        
        
        
        return Output(
            cellData:_cellData.asDriver(onErrorJustReturn: []),
            taskSignal: _prepareTask.asSignal(onErrorJustReturn: Void()),
            noteSignal: _prepareNote.asSignal(onErrorJustReturn: Void())
        )
    }
    
    
    
    
}

//MARK: - Function
extension MainViewModel{
    
    func nextButtonConfigure(_ id: Goal.ID){
        if let data = DataManager.shared.fetchData(type: Goal.self).filter(NSPredicate(format: "id = %@", id)).first{
            if let item =  data.items.filter(NSPredicate(format: "itemComplete = %d", false)).first{
                
                DataManager.shared.updateGoalItem(item:item , with: ["itemComplete" : true])
                
                if data.items.filter(NSPredicate(format: "itemComplete = %d", false)).count == 0{
                    DataManager.shared.updateData(object: data, with: ["completion":true])
                    print("완료했습니다.")
                }
            }else{
                print("해당 아이템이 없습니다.")
            }
           
        }else{
            print("그 id의 값은 없습니다.")
        }
        
    }
    
    //버튼 눌렀을 때 업부에 대한 아이템 완료로 바꾸기
    func configureCell(_ cell: HomeItemCell, at index: Int) {
        cell.completeButtonTapped
            .subscribe(onNext: {
                
                //let data = self.objectData[index]
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
    
    func collectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<MainModel>{
        return RxCollectionViewSectionedReloadDataSource <MainModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch dataSource[indexPath]{
                case .tasksItem(value: let value):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taskCell", for: indexPath) as? TaskCell else { return UICollectionViewCell()}
                    cell.setView(value)
                    cell.bind(self)
                    return cell
                case .notesItem(value: let value):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                    cell.backgroundColor = .blue
                    return cell
                }
            },configureSupplementaryView: {dataSource,collectionView,kind,indexPath -> UICollectionReusableView in
                switch kind{
                case UICollectionView.elementKindSectionHeader:
                    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HomeHeaderView else { return UICollectionReusableView()}
                    
                    let text = dataSource.sectionModels[indexPath.section].title
                    header.setDate(text,indexPath.section)
                    header.bind(self)
                   
                    return header
                default:
                    fatalError()
                }
            }
        )
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


enum MainItem{
    case tasksItem(value: Goal)
    case notesItem(value: Note)
}

enum MainModel{
    case tasks(title: String, items: [Item])
    case notes(title: String, items: [Item])
}

extension MainModel:SectionModelType{
    
    typealias Item = MainItem
    
    init(original: MainModel, items: [Item]) {
        switch original{
        case .tasks(title: let title, items: _):
            self = .tasks(title: title, items: items)
        case .notes(title: let title, items: _):
            self = .notes(title: title, items: items)
        }
    }
    
    var items: [MainItem] {
        switch self{
            
        case .tasks(title: _, items: let items):
            return items.map{$0}
        case .notes(title: _, items: let items):
            return items.map{$0}
        }
    }
    
    var title: String{
        switch self{
            
        case .tasks(title: let title, items: _):
            return title
        case .notes(title: let title, items: _):
            return title
        }
    }
}

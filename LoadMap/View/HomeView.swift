//
//  HomeView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/17.
//

import UIKit
import SnapKit
import RxDataSources
import Then
import RxSwift
import RxCocoa

class HomeView: UIViewController{
    
    let bag = DisposeBag()
    
    let tableView = UITableView().then{
        $0.register(HomeItemCell.self, forCellReuseIdentifier: "goalItemCell")
        $0.register(HomeHeaderCell.self, forHeaderFooterViewReuseIdentifier: "Header")
    }
    
     var dataSource: RxTableViewSectionedReloadDataSource<Home>{
        return RxTableViewSectionedReloadDataSource<Home>(
            configureCell: { dataSource, view, index, item in
                guard let cell = view.dequeueReusableCell(withIdentifier: "goalItemCell",for: index) as? HomeItemCell else { return UITableViewCell()}
                cell.expanded = dataSource.sectionModels[index.section].header.expanded
                cell.isHidden = cell.expanded
                return cell
            }
        )}
    

    
    let data: [Home] = [
        Home(header: GoalHeader(icon: "😺", title: "title", startDay: Date(), endDay: Date()), items: [GoalItem(itemName: "Item1", itemComplete: false),GoalItem(itemName: "Item1", itemComplete: false),GoalItem(itemName: "Item1", itemComplete: false)]),
        Home(header: GoalHeader(icon: "abc", title: "title", startDay: Date(), endDay: Date()), items: [GoalItem(itemName: "Item1", itemComplete: false),GoalItem(itemName: "Item1", itemComplete: false),GoalItem(itemName: "Item1", itemComplete: false)]),
        Home(header: GoalHeader(icon: "abc", title: "title", startDay: Date(), endDay: Date()), items: [GoalItem(itemName: "Item1", itemComplete: false),GoalItem(itemName: "Item1", itemComplete: false),GoalItem(itemName: "Item1", itemComplete: false)])
    ]
    

    let items =  BehaviorRelay<[Home]>(value: [])
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        //tableView.delegate = self
        bind()
        layout()
    }
}

extension HomeView{

  
    
    func bind(){
        self.items.accept(data)
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: bag)

  

    }
    
    private func layout(){
        view.addSubview(tableView)
        
        // 테이블뷰 오토레이아웃
        tableView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


extension HomeView: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? HomeHeaderCell else {return nil}
        headerView.viewMore.rx.tap
            .subscribe(onNext: {
                
                let rowCountInSection = tableView.numberOfRows(inSection: section)
                
                for row in 0..<rowCountInSection {
                    let indexPath = IndexPath(row: row, section: section)
                    var data = self.items.value
                    data[section].header.expanded = true
                    self.items.accept(data)
                    let cell = tableView.cellForRow(at: indexPath)
                    //cell?.isHidden = true
                    tableView.beginUpdates()
                    self.tableView.reloadSections([indexPath.section], with: .fade)
                    tableView.endUpdates()
                }
                
            })
            .disposed(by: bag)
        headerView.emojlabel.text = data[section].header.icon
        headerView.titleLabel.text = data[section].header.title
        return headerView
    }
    

    
}

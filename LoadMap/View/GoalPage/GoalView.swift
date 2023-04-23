//
//  GoalView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/17.
//

import UIKit
import SnapKit
import Then
import RealmSwift
import RxSwift
import RxCocoa


class GoalView: UIViewController{
    
    
    lazy var viewModel = GoalViewModel()
    
    let bag = DisposeBag()
    
    let tableView = UITableView().then{
        $0.register(HomeItemCell.self, forCellReuseIdentifier: "goalItemCell")
        $0.register(HomeHeaderCell.self, forHeaderFooterViewReuseIdentifier: "Header")
    }
    
    let addButton = UIButton().then{
        $0.backgroundColor = .yellow
    }

    override func viewDidLoad() {
        super.viewDidLoad()
  
        bind(viewModel)
        layout()
    }
}



extension GoalView{

    func bind(_ VM: GoalViewModel){
        let input = GoalViewModel.Input()
        let output = VM.inOut(input: input)
        
        
        addButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.pushViewController(GoalAddView(), animated: true)
            })
            .disposed(by: bag)
        
        output.cellData
            .drive(tableView.rx.items(cellIdentifier: "goalItemCell",cellType: HomeItemCell.self)){row,data,cell in
                
                cell.goalTitleLabel.text = data.title
                //cell.backgroundColor = data.boxColor
                
            }
            .disposed(by: bag)
    }
    
    private func layout(){
        [tableView,addButton].forEach{
            view.addSubview($0)
        }
        
        // 테이블뷰 오토레이아웃
        tableView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        //글작성 버튼 오토레이아웃
        addButton.snp.makeConstraints{
            $0.width.height.equalTo(50)
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
}

//MARK: - TableView DataSource
//extension GoalView: UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        if goalData![section].expanded{
//            return goalData?[section].items.count ?? 0
//        }else{
//            return 0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalItemCell") as? HomeItemCell else { return UITableViewCell()}
//        
//        cell.titleLabel.text = goalData?[indexPath.row].title
//        
//        return cell
//        
//    }
//    
//    
//}

//MARK: - TableView Delegate
//extension GoalView: UITableViewDelegate{
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        goalData?.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? HomeHeaderCell else {return nil}
//        headerView.viewMore.tag = section
//        headerView.viewMore.addTarget(self, action: #selector(sectionButtonTapped(sender:)), for: .touchDown)
//
//        headerView.emojlabel.text = goalData?[section].icon
//        headerView.titleLabel.text = goalData?[section].title
//        return headerView
//    }
//    @objc func sectionButtonTapped(sender: UIButton){
//        let section = sender.tag
//        try! realm.write{
//            goalData?[section].expanded.toggle()
//        }
//
//        tableView.reloadSections([section], with: .automatic)
//    }
//}
//
//  GoalAddView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/18.
//

import UIKit
import SnapKit
import Then
import RealmSwift
import RxSwift
import RxDataSources


class GoalAddView:UIViewController{
    
    let bag = DisposeBag()
    let realm = try! Realm()
    
    
    //뷰모델
    private let viewModel = GoalAddViewModel()
    
    deinit{
        print("종료되었습니다.")
        
    }
    
    let tableView = UITableView().then{
        $0.register(GoalAddMainCell.self, forCellReuseIdentifier: "mainCell")
        $0.register(GoalDateCell.self, forCellReuseIdentifier: "dateCell")
        $0.register(GoalColorCell.self, forCellReuseIdentifier: "colorCell")
        $0.register(GoalItemCell.self, forCellReuseIdentifier: "itemCell")
        $0.separatorInset = .zero
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 60.0
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bind(viewModel)
        layout()
        navigationBarAdd()
    }
    
    
}

//MARK: - Layout 및 UIUpdate.
extension GoalAddView{
    
    // tableView Cell 에 대한 설정

    
    func bind(_ VM: GoalAddViewModel){
        

        let input = GoalAddViewModel.Input()
        let output = VM.inOut(input: input)
        
        //TableView DataSource 구현
            output.tableData
                .drive(tableView.rx.items(dataSource: VM.tableViewDataSource()))
                .disposed(by: bag)

        
        let mainCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        output.testData
            .bind(onNext: {value in
                print(value)
            })
            .disposed(by: bag)
        
        
        
        
    }
    
    private func layout(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(20)
        }
    }
}

//MARK: - NavigationBar
extension GoalAddView{
    private func navigationBarAdd(){
        let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButton))
        self.navigationItem.rightBarButtonItem = addButton
    }
    @objc func addButton(){
        
        viewModel.dataSave()

        self.navigationController?.popViewController(animated: true)
    }
}

extension GoalAddView: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return UITableView.automaticDimension
        }else{
            return 60.0
        }
    }
}



//
//  GoalAddView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/18.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxDataSources


class GoalAddView:UIViewController{
    
    let bag = DisposeBag()
    
    //뷰모델
    private let viewModel: GoalAddViewModel
    
    
    init(viewModel: GoalAddViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("종료되었습니다.")
    }
    
    let tableView = UITableView().then{
        $0.register(GoalAddMainCell.self, forCellReuseIdentifier: "mainCell")
        $0.register(GoalDateCell.self, forCellReuseIdentifier: "dateCell")
        $0.register(GoalColorCell.self, forCellReuseIdentifier: "colorCell")
        $0.register(GoalItemCell.self, forCellReuseIdentifier: "itemCell")
        $0.separatorInset = .zero
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 60.0
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
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
        
        output.addPageModal
            .emit(onNext: {
                let view = GoalItemPageView()
                view.bind(self.viewModel)
                self.present(view, animated: true)
            })
            .disposed(by: bag)
        
        output.emptyAlert
            .emit(onNext: {
                print($0)
                print("내용이 없습니다.")
            })
            .disposed(by: bag)
        
        output.successAdd
            .emit(onNext: {
                print("내용을 추가했습니다.")
                //self.navigationController?.popViewController(animated: true)
            })
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
        
       
    }
}





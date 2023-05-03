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

//TODO
///item 추가 시 스크롤 자동으로 맨 밑으로 가도록 설정
///키보드가 나왔을 때 위치 조정
///추가된 Item의 cell 생성
///추가된 tiem에 삭제 이벤트 구현
///달력 오늘 날짜보다 뒤에 선택하는 걸 불가능하게 구현

class GoalAddView:UIViewController{
    
    let bag = DisposeBag()
    deinit{
        
        print("GoalAddView   \(#function)")
    }
    //뷰모델
    private let viewModel: GoalAddViewModel
    
    //초기화
    init(viewModel: GoalAddViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    let tableView = UITableView().then{
        $0.register(GoalAddMainCell.self, forCellReuseIdentifier: "mainCell")
        $0.register(GoalDateCell.self, forCellReuseIdentifier: "dateCell")
        $0.register(GoalColorCell.self, forCellReuseIdentifier: "colorCell")
        $0.register(GoalItemCell.self, forCellReuseIdentifier: "itemCell")
        $0.register(GoalTaskCell.self, forCellReuseIdentifier: "taskCell")
        $0.separatorInset = .zero
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 200
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
    
    
    func bind(_ VM: GoalAddViewModel){
        
        let input = GoalAddViewModel.Input()
        let output = VM.inOut(input: input)
        
        //TableView DataSource 구현
        output.tableData
            .drive(tableView.rx.items(dataSource: VM.tableViewDataSource()))
            .disposed(by: bag)
        
        output.emptyAlert
            .emit(onNext: {
                print($0)
                print("내용이 없습니다.")
            })
            .disposed(by: bag)
        
        output.successAdd
            .emit(onNext: {[weak self] in
                print("내용을 추가했습니다.")
                guard let self = self else {return }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
        
    

    }
    
    private func layout(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
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




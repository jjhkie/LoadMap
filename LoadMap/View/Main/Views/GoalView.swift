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


//TODO :
/// progressBar animation 적용
/// 진행중인 것과 예정인 것 나누기 
final class GoalView: UITableViewController{
    
    private let bag = DisposeBag()
    
    private let viewModel: GoalViewModel
    
    private let addButton = UIButton().then{
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .yellow
        config.image = UIImage(systemName: "plus")
        config.imagePadding = 10
        $0.configuration = config
    }
    
    init(viewModel: GoalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        attribute()
        bind(GoalViewModel())
        layout()
    }
}

//MARK: - Bind
extension GoalView{
    func bind(_ VM: GoalViewModel){
        let input = GoalViewModel.Input()
        let output = VM.inOut(input: input)
        
        
        //추가 버튼 클릭 이벤트
        //클릭 시 AddPage로 이동
        addButton.rx.tap
            .subscribe(onNext: {
                let view = GoalAddView(viewModel: GoalAddViewModel())
                self.navigationController?.pushViewController(view, animated: true)
            })
            .disposed(by: bag)
        
        output.cellData
            .drive(tableView.rx.items(dataSource: VM.tableDataSource))
            .disposed(by: bag)
        
        tableView.rx.modelSelected(Goal.self)
            .bind(onNext: {
                let view = GoalDetailView(screenData: $0)
                self.navigationController?.pushViewController(view, animated: true)
                //self.present(view, animated: true)
            })
            .disposed(by: bag)
    }
    
}

//MARK: - Layout
extension GoalView{
    
    private func attribute(){
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.separatorStyle = .none
        tableView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 10)
        tableView.register(HomeItemCell.self, forCellReuseIdentifier: "goalItemCell")
        
    }
    private func layout(){
        [addButton].forEach{
            view.addSubview($0)
        }
        
        
        //글작성 버튼 오토레이아웃
        addButton.snp.makeConstraints{
            $0.width.height.equalTo(50)
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
}

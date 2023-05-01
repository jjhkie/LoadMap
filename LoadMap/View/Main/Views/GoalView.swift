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


//TODO : items에서 complete == false 인 값 중 제일 앞에 있는 값 가져오기


final class GoalView: UIViewController{
    
    private let bag = DisposeBag()
    
    private let viewModel: GoalViewModel
    
    private let tableView = UITableView().then{
        $0.separatorStyle = .none
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 10)
        $0.register(HomeItemCell.self, forCellReuseIdentifier: "goalItemCell")
    }
    
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
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
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
        
        //테이블뷰 구현
        output.cellData
            .drive(tableView.rx.items(cellIdentifier: "goalItemCell",cellType: HomeItemCell.self)){row,data,cell in
                
                let completedCount = data.items.filter{
                    $0.itemComplete == true
                }.count
                
                let totalCount = data.items.count
                
                cell.setData(data)
                cell.progressValue(completedCount, totalCount)
                self.viewModel.configureCell(cell, at: row)
            }
            .disposed(by: bag)
        
        
        tableView.rx.modelSelected(Goal.self)
            .subscribe(onNext: {value in
                print(value)
            })
            .disposed(by: bag)
    }

}

//MARK: - Layout
extension GoalView{
    private func layout(){
        [tableView,addButton].forEach{
            view.addSubview($0)
        }
        
        // 테이블뷰 오토레이아웃
        tableView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        //글작성 버튼 오토레이아웃
        addButton.snp.makeConstraints{
            $0.width.height.equalTo(50)
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
}

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
        $0.separatorStyle = .none
        
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 10)
        $0.register(HomeItemCell.self, forCellReuseIdentifier: "goalItemCell")
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "emptyCell")
    }
    
    let addButton = UIButton().then{
        $0.backgroundColor = .yellow
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
                if data.title == nil{
                   print("abc")
            
                }else{
                    
                    cell.setData(data)
                    
                    for value in data.items{
                        print(value)
                    }
                }
            }
            .disposed(by: bag)

        
        tableView.rx.modelSelected(Goal.self)
            .subscribe(onNext: {value in
                let view = GoalDetailView()
                view.screenData = value
                self.present(view, animated: true)
            })
            .disposed(by: bag)
    }
    
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

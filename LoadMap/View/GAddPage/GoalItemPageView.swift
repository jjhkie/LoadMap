//
//  GoalItemPageView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/25.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift


final class GoalItemPageView: UIViewController{
    
    private let bag = DisposeBag()
    
    private let containerView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    private let itemTextField = UITextField()
    
    private let itemAddButton = UIButton().then{
        $0.backgroundColor = .red
    }
    
    private let tableView = UITableView().then{
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
    }
}

extension GoalItemPageView{
    
    func bind(_ VM: GoalAddViewModel){
        VM.worksData.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "cell",cellType: UITableViewCell.self)){row,data,cell in
                
                cell.textLabel?.text = data
            }
            .disposed(by: bag)
    }
    
    private func layout(){
        [itemTextField,itemAddButton].forEach{
            containerView.addArrangedSubview($0)
        }
        
        [containerView,tableView].forEach{
            view.addSubview($0)
        }
        
        itemTextField.snp.makeConstraints{
            $0.height.equalTo(50)
        }
        
        itemAddButton.snp.makeConstraints{
            $0.width.height.equalTo(50)
        }
        
        containerView.snp.makeConstraints{
            $0.bottom.trailing.leading.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(containerView.snp.top)
        }
    }
}

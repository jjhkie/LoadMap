//
//  GoalItemCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/20.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class GoalItemCell: UITableViewCell{
    
    let bag = DisposeBag()
    
    private let emojiView = UIImageView().then{
        $0.image = UIImage(systemName: "list.bullet.clipboard")
        $0.tintColor = .orange
    }
    
    private let containerView = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    let titleContainerView = UIView()
    
    let titleLabel = UILabel().then{
        $0.text = "할 일"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    let addButton = UIButton().then{
        $0.layer.cornerRadius = 10
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        
    }
    
    private let workTableView = UITableView().then{
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GoalItemCell{
    
    func bind(_ VM: GoalAddViewModel){
        

        addButton.rx.tap
            .bind(to: VM._addPageModal)
            .disposed(by: bag)
        
        VM.worksData.asDriver(onErrorJustReturn: [])
            .drive(workTableView.rx.items(cellIdentifier: "cell",cellType: UITableViewCell.self)){row,data,cell in
                
                print("item table")
                cell.textLabel?.text = data
            }
            .disposed(by: bag)
    }
    
    
    private func layout(){
        
        [titleLabel,addButton].forEach{
            titleContainerView.addSubview($0)
        }
        
        [titleContainerView,workTableView].forEach{
            containerView.addArrangedSubview($0)
        }
        
        [emojiView,containerView].forEach{
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.leading.bottom.equalToSuperview()
        }
        
        emojiView.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 5, bottom: 0, right: 0))
            $0.height.width.equalTo(20)
        }
        
        containerView.snp.makeConstraints{
            $0.top.equalTo(emojiView.snp.top)
            $0.leading.equalTo(emojiView.snp.trailing).offset(15)
            $0.trailing.bottom.equalToSuperview()
        }
        
        addButton.snp.makeConstraints{
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(20)
        }
        
        workTableView.snp.makeConstraints{
            $0.height.equalTo(400)
        }
    }
}

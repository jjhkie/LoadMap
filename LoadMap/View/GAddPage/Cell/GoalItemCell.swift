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
    
    private let bag = DisposeBag()
    
    private lazy var baseView = BaseView(editEnable: false).then{
        $0.emojiImage.image = UIImage(systemName: "list.bullet.clipboard")
        $0.emojiImage.tintColor = .cyan
        
        $0.titleTextView.text = "업무"
        $0.titleTextView.textColor = .lightGray
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
        
        
        VM.worksData.asDriver(onErrorJustReturn: [])
            .drive(workTableView.rx.items(cellIdentifier: "cell",cellType: UITableViewCell.self)){row,data,cell in
                
                print("item table")
                cell.textLabel?.text = data
            }
            .disposed(by: bag)
    }
    
    
    private func layout(){
        contentView.addSubview(baseView)
        
        baseView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
    }
}

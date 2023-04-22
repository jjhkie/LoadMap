//
//  GoalItemCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/20.
//

import UIKit
import SnapKit
import Then
class GoalItemCell: UITableViewCell{
    
    private let containerView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    let titleLabel = UILabel()
    
    let contentTextView = UITextField()
    
    let addButton = UIButton().then{
        $0.backgroundColor = .red
       
    }
  
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GoalItemCell{
    private func layout(){
        
        [titleLabel,contentTextView,addButton].forEach{
            containerView.addArrangedSubview($0)
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        addButton.snp.makeConstraints{
            $0.width.height.equalTo(30)
        }
    }
}

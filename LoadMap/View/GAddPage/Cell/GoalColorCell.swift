//
//  GoalColorCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/20.
//

import UIKit
import SnapKit
import Then

class GoalColorCell:UITableViewCell{
    
    private let containerView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    private let titleLabel = UILabel().then{
        $0.text = "색상"
    }
    
    let colorButton = UIColorWell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GoalColorCell{
    private func layout(){
        
        [titleLabel,colorButton].forEach{
            containerView.addArrangedSubview($0)
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        
    }
}

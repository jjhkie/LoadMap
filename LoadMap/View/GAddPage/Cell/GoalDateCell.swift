//
//  GoalDateCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/20.
//

import UIKit
import SnapKit
import Then


class GoalDateCell: UITableViewCell{
    
    private let containerView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    let titleLabel = UILabel()
    
    let dateLabel = UILabel().then{
        $0.textAlignment = .right
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GoalDateCell{
    private func layout(){
        [titleLabel,dateLabel].forEach{
            containerView.addArrangedSubview($0)
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints{
            $0.width.equalTo(titleLabel.snp.width).multipliedBy(7)
        }
    }
}

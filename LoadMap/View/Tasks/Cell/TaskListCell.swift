//
//  TaskListCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/10.
//

import UIKit
import SnapKit
import Then

final class TaskListCell: UITableViewCell{
    
    let containerStackView = UIStackView().then{
        $0.axis = .horizontal
    }
    
    let dateLabel = UILabel()
    
    let titleLabel = UILabel().then{
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.textAlignment = .left
    }
    
    let statusLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension TaskListCell{
    
    
    func setView(_ data: Task){
        dateLabel.text = data.dateOfCreation.dayStringText
        
        titleLabel.text = data.title
        
        statusLabel.text = "진행중"
    }
    
    private func layout(){
        [dateLabel,titleLabel,statusLabel].forEach{
            containerStackView.addArrangedSubview($0)
        }
        
        
        contentView.addSubview(containerStackView)
        
        
        containerStackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}

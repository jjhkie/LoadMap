//
//  GoalTaskCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/02.
//

import UIKit
import SnapKit

final class ItemCell: UITableViewCell{
    
    let taskLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ItemCell{
    
    private func layout(){
        contentView.addSubview(taskLabel)
        
        taskLabel.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 0))
        }
    }
}

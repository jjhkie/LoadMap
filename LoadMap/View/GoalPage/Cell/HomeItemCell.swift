//
//  HomeItemCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/17.
//

import UIKit
import SnapKit

class HomeItemCell: UITableViewCell{
    var expanded = false
    var goalTitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeItemCell{
    private func layout(){
        contentView.addSubview(goalTitleLabel)
        
        goalTitleLabel.snp.makeConstraints{
            $0.top.leading.equalToSuperview()
        }
        
    }
}

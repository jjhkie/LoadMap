//
//  GoalAddMainCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/20.
//

import UIKit
import SnapKit
import Then

class GoalAddMainCell: UITableViewCell{
    
    let containserStackView = UIStackView().then{
        $0.axis = .horizontal
    }
    
    let imageTextView = UITextField().then{
        $0.placeholder = "이미지"
    }
    
    let titleTextView = UITextField().then{
        $0.placeholder = "글제목"
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GoalAddMainCell{
    
    private func layout(){
        [imageTextView,titleTextView].forEach { view in
            containserStackView.addArrangedSubview(view)
        }
        
        
        contentView.addSubview(containserStackView)
        
        containserStackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        imageTextView.snp.makeConstraints{
            $0.width.equalToSuperview().dividedBy(4)
        }
        titleTextView.snp.makeConstraints{
            $0.width.equalTo(imageTextView.snp.width).multipliedBy(3)
        }
        
    }
}


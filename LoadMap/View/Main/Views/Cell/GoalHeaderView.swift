//
//  GoalHeaderView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/03.
//

import UIKit
import SnapKit

final class GoalHeaderView: UIStackView{
    
    let label = UILabel().then{
        $0.text = "아이템의 개수는 "
        $0.textColor = .black
        
        
    }
    
    let button = UIButton().then{
        $0.setTitle(">", for: .normal)
        //$0.configuration = $0.fillGray
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension GoalHeaderView{
    
    private func attribute(){
        backgroundColor = .white
        layer.cornerRadius = 10
        axis = .horizontal
        layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        isLayoutMarginsRelativeArrangement = true
    }
    private func layout(){
        [button,label].forEach{
            addArrangedSubview($0)
        }
    }
}

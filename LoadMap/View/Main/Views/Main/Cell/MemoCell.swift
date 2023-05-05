//
//  NoteCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/05.
//

import UIKit
import Then
import SnapKit

final class MemoCell: UICollectionViewCell{
    
    private let containerStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.spacing = 20
    }
    
    private let priorityView = UIView()
    
    private let contentLabel = UILabel().then{
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.font = .dovemayoFont(ofSize: 14)
    }
    
    private let timeBefore = UILabel().then{
        $0.font = .dovemayoFont(ofSize: 12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MemoCell{
    
    func setView(){
        priorityView.backgroundColor = .red
        
        contentLabel.text = "abcdfeakljgeklgjaklgjwkgerlg"
        
        timeBefore.text = "1시간전"
    }
    
    private func layout(){
        [priorityView,contentLabel,timeBefore].forEach{
            containerStackView.addArrangedSubview($0)
        }
        
        priorityView.snp.makeConstraints{
            $0.width.equalTo(2)
            
        }
        
        contentView.addSubview(containerStackView)
        
        
        containerStackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}

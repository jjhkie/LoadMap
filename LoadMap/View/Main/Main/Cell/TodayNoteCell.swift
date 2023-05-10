//
//  NoteCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/05.
//

import UIKit
import Then
import SnapKit

final class TodayNoteCell: UICollectionViewCell{
    
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

extension TodayNoteCell{
    
    func setView(_ data: Note){
        
        switch data.important{
        case "low":
            priorityView.backgroundColor = .green
        case "middle":
            priorityView.backgroundColor = .blue
        case "high":
            priorityView.backgroundColor = .red
        default:
            break
        }
        
        
        contentLabel.text = data.noteContent
        
        ///작성 시간 출력
        let time = Date().koreanTime.dayOfTime - data.dateOfCreation.dayOfTime
        
        if time == 0{
            timeBefore.text = "방금 전"
        }else{
            timeBefore.text = "\(time)시간 전"
        }
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

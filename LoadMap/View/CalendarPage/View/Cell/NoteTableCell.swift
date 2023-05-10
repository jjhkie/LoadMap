//
//  NoteTableCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/08.
//

import UIKit
import SnapKit
import Then

//TODO
///첫 번째 문장을 제목으로 인식하는 건 어때?

final class NoteTableCell: UITableViewCell{
    
    private let containerView = UIStackView().then{
        $0.axis = .horizontal
        $0.layer.cornerRadius = 10
        $0.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    }
    
    //leading icon
    private let iconContainer = UIView().then{
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private let iconView = CircleView(size: 10)
    
    //trailing content View
    private let contentViewContainer = UIView()
    
    private let dateLabel = UILabel().then{
        $0.textColor = .lightGray
        $0.numberOfLines = 2
    }
    
    private let contentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: nil)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension NoteTableCell{
    
    func setView(_ data: Note){
        dateLabel.text = "\(data.dateOfCreation.dayOfTimeString)"
        contentLabel.text = data.noteContent
    }
    
    private func layout(){
        
        //Icon View
        iconContainer.addSubview(iconView)
        
        iconContainer.snp.makeConstraints{
            $0.width.equalTo(20)
        }
        
        iconView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
        
        //contentView
        [dateLabel,contentLabel].forEach{
            contentViewContainer.addSubview($0)
        }
        
        dateLabel.snp.makeConstraints{
            $0.leading.trailing.top.equalToSuperview().offset(10)
            $0.height.equalTo(30)
        }
        
        contentLabel.snp.makeConstraints{
            $0.top.equalTo(dateLabel.snp.bottom).offset(3)
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        
        ///전체 뷰
        [iconContainer,contentViewContainer].forEach{
            containerView.addArrangedSubview($0)
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
    }
}

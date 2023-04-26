//
//  GoalDateCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/20.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift



class GoalDateCell: UITableViewCell{
    
    let bag = DisposeBag()
    
    private let emojiView = UIImageView().then{
        $0.image = UIImage(systemName: "calendar")
        $0.tintColor = .purple
    }
    
    private let containerView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    let titleLabel = UILabel().then{
        $0.text = "기간"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    private let dateStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 10
    }
    
    let startDate = UIDatePicker().then{
        $0.locale = Locale(identifier: "ko-KR")
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .compact
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
    }
    
    let dateCenterLine = UILabel().then{
        $0.text = "~"
        $0.textAlignment = .center
        
    }
    
    let endDate = UIDatePicker().then{
        $0.locale = Locale(identifier: "ko-KR")
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .compact
        
    }
    
    let freeSpace = UIView().then{
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layout()
        
   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GoalDateCell{
    
    func bind(_ VM: GoalAddViewModel){
        startDate.rx.date
            .bind(to: VM._startDate)
            .disposed(by: bag)
        
        endDate.rx.date
            .bind(to: VM._endDate)
            .disposed(by: bag)
    }
    
    private func layout(){
        
        [startDate,dateCenterLine,endDate,freeSpace].forEach{
            dateStackView.addArrangedSubview($0)
        }
        
        [titleLabel,dateStackView].forEach{
            containerView.addArrangedSubview($0)
        }
        
        [emojiView,containerView].forEach{
            contentView.addSubview($0)
        }
        

        emojiView.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 5, bottom: 0, right: 0))
            $0.height.width.equalTo(20)
        }
        
        containerView.snp.makeConstraints{
            $0.top.equalTo(emojiView.snp.top)
            $0.leading.equalTo(emojiView.snp.trailing).offset(15)
            $0.trailing.bottom.equalToSuperview()
        }
        
        startDate.snp.makeConstraints{
            $0.width.equalTo(100)
        }
        
        endDate.snp.makeConstraints{
            $0.width.equalTo(100)
    
        }
        dateCenterLine.snp.makeConstraints{
            $0.width.equalTo(10)
            $0.height.equalToSuperview()
        }
    }
}

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
    
    private lazy var baseView = BaseView(editEnable: false).then{
        $0.emojiImage.image = UIImage(systemName: "calendar")
        $0.emojiImage.tintColor = .orange
        
        $0.titleTextView.text = "기간"
    }

    private lazy var dateStackView = UIStackView().then{
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
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: bag)
        startDate.rx.date
            .bind(to: VM._startDate)
            .disposed(by: bag)
        
        endDate.rx.date
            .bind(to: VM._endDate)
            .disposed(by: bag)
    }
    
    private func layout(){
        
        contentView.addSubview(baseView)
        
        baseView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        [startDate,dateCenterLine,endDate,freeSpace].forEach{
            dateStackView.addArrangedSubview($0)
        }
        [dateStackView].forEach{
            baseView.infoStackView.addArrangedSubview($0)
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

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
import FSCalendar



final class TaskDateCell: UITableViewCell{
    
    let bag = DisposeBag()
    
    private let containerStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.spacing = 15
    }
    
    private let emojiImage = UIImageView().then{
        $0.image = Constants.Images.calendarImage
        $0.tintColor = .orange
    }
    
    private let titleLabel = UILabel().then{
        $0.text = "기간"
        $0.font = Constants.Fonts.topItem
        $0.textColor = .black
        $0.backgroundColor = .white
        
    }
    
    
    let dayButton = UIButton().then{
        $0.setTitle("하루", for: .normal)
        //$0.configuration = $0.fillGray
    }
    
    let peridButton = UIButton().then{
        $0.setTitle("기간", for: .normal)
        //$0.configuration = $0.fillGray
    }

    private let containerView = UIView().then{
        $0.backgroundColor = .white
    }
    
    private let oneDayCalendar = UIDatePicker().then{
        $0.locale = Locale(identifier: "ko-KR")
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .compact
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    let peridCalendar = FSCalendar()
    
    let freeSpace = UIView().then{
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        layout()
        
   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TaskDateCell{
    
    func reload() {
        guard let tableView = superview as? UITableView, let indexPath = tableView.indexPath(for: self) else { return }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func bind(viewmodel VM: TaskAddViewModel){
        oneDayCalendar.rx.date
            .subscribe(onNext: {
                VM.startDateOnNext($0)
                VM.endDateOnNext($0)
            })
            .disposed(by: bag)
        
        // 버튼 이벤트
        dayButton.rx.tap
            .subscribe(onNext: {
                VM.dateButtonOnNext(true)
            })
            .disposed(by: bag)

        peridButton.rx.tap
            .subscribe(onNext: {
                VM.dateButtonOnNext(false)
            })
            .disposed(by: bag)


        VM._dateButton
            .bind(onNext: {[weak self] in
                guard let self = self else {return}
                if $0{
                    self.oneDayCalendar.isHidden = false
                    self.peridCalendar.isHidden = true
                    containerView.snp.updateConstraints{
                        $0.height.equalTo(100)
                    }
                    self.reload()
                }else{

                    self.oneDayCalendar.isHidden = true
                    self.peridCalendar.isHidden = false
                    containerView.snp.updateConstraints{
                        $0.height.equalTo(200)
                    }
                    self.reload()
                }
            })
            .disposed(by: bag)
    }
    
    private func layout(){
        
        //제목 및 버튼을 담은 스택뷰
        [emojiImage,titleLabel,dayButton,peridButton,freeSpace].forEach{
            containerStackView.addArrangedSubview($0)
        }
        
        emojiImage.snp.makeConstraints{
            $0.width.height.equalTo(20)
        }
        
        [oneDayCalendar,peridCalendar].forEach{
            containerView.addSubview($0)
        }
        //contentView
        [containerStackView,containerView].forEach{
            contentView.addSubview($0)
        }

        containerStackView.snp.makeConstraints{
            $0.leading.top.trailing.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 5, bottom: 0, right: 0))
        }
        
        containerView.snp.makeConstraints{
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        oneDayCalendar.snp.makeConstraints{
            $0.top.leading.equalToSuperview()
        }
        peridCalendar.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
      
    }
}

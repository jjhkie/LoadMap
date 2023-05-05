//
//  TaskCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/05.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

//TODO
///완료버튼 클릭 시 두번 실행 / cell마다 viewmodel을 만들어주는건가??

//MARK: - Init & Views
final class TaskCell: UICollectionViewCell{
    
    var cellId: Goal.ID?
    
    let bag = DisposeBag()
    
    // [Stack] 전체 스택뷰
    private let containerView = UIStackView().then{
        $0.axis = .vertical
        //$0.distribution = .fill
        $0.spacing = 5
    }
    
    
    // >> Start
    // [ Stack ] 시작 날짜 담을 스택뷰
    private let startDateView = UIView()
    
    // [ View ] 시작 표시를 나타낼 원
    private let startCircle = CircleView(size: 10)
    //[ Label ] 시작 날짜를 표시할 라벨
    private let startDateLabel = UILabel().then{
        $0.font = .dovemayoFont(ofSize: 14)
        $0.textColor = .lightGray
    }
    
    
    // >> Middle
    // [ Stack ] 중앙  스택뷰
    private let middleView = UIView().then{
        $0.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    // [ view ] 좌측 라인 뷰
    private let lineContainerView = UIView().then{
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    }
    private let infoLine = UIView()
    
    // [ Stack ] 정보를 담을 뷰
    private let taskStackView = UIStackView().then{
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    private let currentTaskLabel = UILabel().then{
        $0.font = .dovemayoFont(ofSize: 14)
    }
    
    private let progressBar = UIProgressView()
    
    private let nextTaskLabel = UILabel().then{
        $0.font = .dovemayoFont(ofSize: 14)
    }
    
    private let buttonView = UIView()
    
    private let nextButton = UIButton().then{
  
        var config = UIButton.Configuration.filled()
        config.titlePadding = 10
        var titleAttr = AttributedString.init("완료")
            titleAttr.font = .systemFont(ofSize: 8.0, weight: .heavy)
            config.attributedTitle = titleAttr
        $0.configuration = config
    }
  
    
    //>> End
    // [ Stack ] 마지막 스택뷰
    private let endView = UIView()
    
    private let endCircle = CircleView(size: 10)
    
    private let endDateLabel = UILabel().then{
        $0.font = .dovemayoFont(ofSize: 14)
        $0.textColor = .lightGray
    }
    
    
    // >> info
    // [ View ]
    
    private let titleLabel = UILabel().then{
        $0.font = .dovemayoFont(ofSize: 16)
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    private let descriptionLabel = UILabel().then{
        $0.font = .dovemayoFont(ofSize: 14)
        $0.textColor = .lightGray
        $0.numberOfLines = 0
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - Layout
extension TaskCell{
    func bind(_ VM: MainViewModel){
        nextButton.rx.controlEvent(.touchUpInside)
            .bind(onNext: {[weak self] in
                guard let self = self else {return }
                VM.nextButtonConfigure(self.cellId!)
            })
            .disposed(by: bag)
    }
    
    func setView(_ data: Goal){
        cellId = data.id
        //Start
        startCircle.layer.borderColor = data.boxColor?.uiColor.cgColor
        startDateLabel.text = data.startDay.dayStringText
        
        
        //Middle
        infoLine.backgroundColor = data.boxColor?.uiColor
        currentTaskLabel.text = data.items.first{
            $0.itemComplete == false
        }?.itemName
        
        nextTaskLabel.text = "다음 정보를 가져올 라벨 "
        
        //프로그래스바
        let taskCount = data.items
        let completeData = taskCount.filter{
            $0.itemComplete == true
        }
        
        progressValue(completeData.count, taskCount.count)
        
        //End
        endCircle.backgroundColor = data.boxColor?.uiColor
        endDateLabel.text = data.endDay.dayStringText
        
        //Info
        titleLabel.text = data.title
        descriptionLabel.text = data.content
        
    }
    
    func progressValue(_ complete: Int,_ total: Int){
        progressBar.progress = Float(complete) / Float(total)
    }
    
    private func layout(){
        
        // [ Stack ] 시작 뷰
        
        startDateView.snp.makeConstraints{
            $0.height.equalTo(30)
        }

        
        [startCircle,startDateLabel].forEach{
            startDateView.addSubview($0)
        }
        
        startCircle.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        startDateLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(startCircle.snp.trailing).offset(20)
        }

  
        
        // [ Stack ] 중앙 스택뷰
        

        
        [currentTaskLabel,progressBar,nextTaskLabel].forEach{
            taskStackView.addArrangedSubview($0)
        }
        
        lineContainerView.addSubview(infoLine)
        
        [nextButton].forEach{
            buttonView.addSubview($0)
        }
        
        [lineContainerView,taskStackView,buttonView].forEach{
            middleView.addSubview($0)
        }
        

        
        lineContainerView.snp.makeConstraints{
            $0.width.equalTo(10)
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        infoLine.snp.makeConstraints{
            $0.width.equalTo(1)
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        taskStackView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(infoLine.snp.trailing).offset(10)
            $0.trailing.equalTo(buttonView.snp.leading)
        }
        
        buttonView.snp.makeConstraints{
            $0.width.equalTo(40)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        nextButton.snp.makeConstraints{
            $0.width.height.equalTo(30)
            $0.center.equalToSuperview()
        }


        
        // [Stack ] 마지막 뷰
        [endCircle, endDateLabel].forEach{
            endView.addSubview($0)
        }
        endView.snp.makeConstraints{
            $0.height.equalTo(30)
        }
        endCircle.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        endDateLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(endCircle.snp.trailing).offset(20)
        }

        
        // [Stack ] 전체 뷰
        [startDateView,middleView,endView,titleLabel,descriptionLabel].forEach{
            containerView.addArrangedSubview($0)
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
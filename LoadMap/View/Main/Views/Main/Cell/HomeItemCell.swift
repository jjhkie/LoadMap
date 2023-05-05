//
//  HomeItemCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/17.
//

import UIKit
import SnapKit
import Then
import RxSwift

//TODO : Day 당일, Day 버튼 구현
class HomeItemCell: UITableViewCell{
    
    let bag = DisposeBag()
    
    //Views
    private let progressBar = CustomProgressView()
    
    private let containerView = UIStackView().then{
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.layer.cornerRadius = 5
        $0.axis = .vertical
    }
    
    private let titleLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 26, weight: .bold)
    }
    
    private let descriptionLabel = UILabel().then{
        $0.textColor = .lightGray
    }
    
    private let rightNowItem = UILabel()
    
    let completeButton = UIButton().then{
        $0.setTitle("Check", for: .normal)
        $0.backgroundColor = .red
    }
    
    private let dDayLabel = UILabel()
    
    
    private let itemStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .equalCentering
    }
    
    //Input
    let completeButtonTapped = PublishSubject<Void>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        backgroundColor = .white
        bind()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeItemCell{
    
    func setData(_ item:Goal){
        titleLabel.text = item.title
        descriptionLabel.text = item.content
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: item.startDay, to: item.endDay)
        let daysLeft = components.day!
        
        if daysLeft == 0 {
            dDayLabel.text = "당일"
        }else{
            dDayLabel.text = "D - \(daysLeft)"
        }

        
        let rightNowData = item.items.filter{
            $0.itemComplete == false
        }.first?.itemName
        rightNowItem.text = "\(rightNowData)"
        
        for value in item.items{
            let circle = CircleView(size: 15)
            circle.fillBool = value.itemComplete
            if value.itemComplete{
                circle.backgroundColor = item.boxColor?.uiColor
            }else{
                circle.backgroundColor = .red
            }

            circle.layer.cornerRadius = 5
 
            itemStackView.addArrangedSubview(circle)
        }
    }
    
    func progressValue(_ complete: Int,_ total: Int){
        progressBar.progress = Float(complete) / Float(total)
    }
    
    func bind(){
        completeButton.rx.tap
            .bind(to: completeButtonTapped)
            .disposed(by: bag)
    }
    
    private func layout(){
        
        [titleLabel,descriptionLabel,dDayLabel,rightNowItem,progressBar,completeButton].forEach{
            containerView.addArrangedSubview($0)
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 10))
        }
    }
}
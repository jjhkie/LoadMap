//
//  HomeItemCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/17.
//

import UIKit
import SnapKit
import Then

class HomeItemCell: UITableViewCell{
    
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
    
    //private let creationDate = UILabel()
    
    private let dDayLabel = UILabel()
    
    
    private let itemStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .equalCentering
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeItemCell{
    
    func setData(_ item:Goal){
        titleLabel.text = item.title
        descriptionLabel.text = item.icon
        
        for value in item.items{
            progressBar.dotCount.append(value)
        }
        
       
        
        let components = Calendar.current.dateComponents([.day], from: Date(), to: item.endDay)
        let daysLeft = components.day!
        dDayLabel.text = "D - \(daysLeft)"
        
        
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
    
    private func layout(){
        
//        progressBar.addSubview(itemStackView)
//        
//        itemStackView.snp.makeConstraints{
//            $0.edges.equalToSuperview()
//        }
        
        [titleLabel,descriptionLabel,dDayLabel,progressBar].forEach{
            containerView.addArrangedSubview($0)
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 10))
        }

        titleLabel.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(descriptionLabel.snp.top).offset(-10)
        }
        
        descriptionLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalTo(dDayLabel.snp.top).offset(-15)
        }
        
       
        
    }
}

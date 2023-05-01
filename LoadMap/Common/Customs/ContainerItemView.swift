//
//  ContainerItemView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/01.
//

import UIKit
import SnapKit

final class ContainerItemView: UIView{
    
    var data: Goal
    
    private  var topItemStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    private let topItemImage = UIImageView().then{
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    let topItemLabel = UILabel().then{
        $0.font = Constants.Fonts.topItem
    }
    
    private var itemContentView = UILabel()
    
    init(content : Goal, type : DetailViewType){
        self.data = content
        super.init(frame: .zero)
        
        attribute(type)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContainerItemView{
    
    private func attribute(_ type: DetailViewType){
        switch type{
        case .title:
            topItemImage.image = Constants.Images.startImage
            topItemLabel.text = data.title
            itemContentView.text = data.content
        case .status:
            topItemImage.image = Constants.Images.statusImage
            topItemLabel.text = "Status"
        }
    }
    
    private func layout(){
        
        [topItemImage,topItemLabel].forEach{
            topItemStackView.addArrangedSubview($0)
        }
        
        [topItemStackView,itemContentView].forEach{
            self.addSubview($0)
        }
        
        topItemStackView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        
        itemContentView.snp.makeConstraints{
            $0.leading.equalTo(topItemLabel.snp.leading)
            $0.top.equalTo(topItemStackView.snp.bottom)
            $0.trailing.equalTo(topItemStackView.snp.trailing)
        }
        

        
    }
}

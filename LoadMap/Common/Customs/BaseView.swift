//
//  BaseView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/27.
//

import UIKit
import SnapKit

//bool 값에 따라 수정이 가능하고 안하고 설정할 수 있지않을까?

final class BaseView: UIView{
    
    var editenable : Bool
    
    lazy var emojiImage = UIImageView()
    
    lazy var infoStackView = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    lazy var titleTextView = UITextView().then{
        $0.isEditable = editenable
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    init(editEnable: Bool){
        self.editenable = editEnable
        super.init(frame: .zero)
        layout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseView{
    func updateContent() {
        
        // 새로운 내용으로 레이아웃을 업데이트합니다.
        setNeedsLayout()
        layoutIfNeeded()
    }
    private func layout(){
        [emojiImage,infoStackView].forEach{
            self.addSubview($0)
        }
        emojiImage.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 5, bottom: 0, right: 0))
            $0.height.width.equalTo(20)
        }
        
        infoStackView.addArrangedSubview(titleTextView)
        
        infoStackView.snp.makeConstraints{
            $0.top.equalTo(emojiImage.snp.top)
            $0.leading.equalTo(emojiImage.snp.trailing).offset(15)
            $0.trailing.bottom.equalToSuperview()
        }
        
        titleTextView.snp.makeConstraints{
            $0.height.equalTo(emojiImage.snp.height)
        }
        

    }
}

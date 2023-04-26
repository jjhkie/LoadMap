//
//  GoalAddMainCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/20.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa


final class GoalAddMainCell: UITableViewCell{
    
    private let bag = DisposeBag()
    
    //좌측 이미지
    private let emojiLabel = UIImageView().then{
        //Hugging - 고유 크기를 유지하려는 속성
        $0.image = UIImage(systemName: "star")
        $0.tintColor = .brown
    }
    
    //텍스트필드 감싸는 StackView
    private let textFieldStackView = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    //제목
    private let titleTextView = UITextField().then{
        $0.placeholder = "글제목"
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    
    let textplaceHolder = "설명"
    //설명
    private lazy var descriptionTextField = UITextView().then{
        $0.text = textplaceHolder
        $0.isEditable = true
        $0.textColor = .lightGray
        $0.textAlignment = .justified
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




extension GoalAddMainCell{
    
    func bind(_ VM: GoalAddViewModel){
        descriptionTextField.rx.text.orEmpty
            .subscribe(VM.emojiText)
            .disposed(by: bag)

        titleTextView.rx.text.orEmpty
            .subscribe(VM.titleText)
            .disposed(by: bag)
        
        //[설명 텍스트뷰]에 커서를 뒀을 때 발생하는 이벤트
        descriptionTextField.rx.didBeginEditing
            .subscribe(onNext: {
                if self.descriptionTextField.text == self.textplaceHolder{
                    self.descriptionTextField.text = ""
                    self.descriptionTextField.textColor = .black
                }
            })
            .disposed(by: bag)
        
        //[설명 텍스트뷰]에 커서를 제거했을 때 발생하는 이벤트
        descriptionTextField.rx.didEndEditing
            .subscribe(onNext: {
                if self.descriptionTextField.text.isEmpty{
                    self.descriptionTextField.text = self.textplaceHolder
                    self.descriptionTextField.textColor = .lightGray
                }
            })
            .disposed(by: bag)
        
        
        VM.selectedColor
            .subscribe(onNext: {color in
                
                print(color.uiColor)
            })
            .disposed(by: bag)
    }
    

    
    private func layout(){
        
        [emojiLabel,textFieldStackView].forEach{
            contentView.addSubview($0)
        }
        
        [titleTextView,descriptionTextField].forEach { view in
            textFieldStackView.addArrangedSubview(view)
        }
        
        emojiLabel.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 5, bottom: 0, right: 0))
            $0.height.width.equalTo(20)
        }
        
        textFieldStackView.snp.makeConstraints{
            $0.top.equalTo(emojiLabel.snp.top)
            $0.leading.equalTo(emojiLabel.snp.trailing).offset(15)
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        

    }
}


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
    
    private let titlePlaceHolder = "제목"
    
    private let descriptionPlaceHolder = "설명"
    
    private lazy var baseView = BaseView(editEnable: true).then{
        $0.emojiImage.image = UIImage(systemName: "star")
        $0.emojiImage.tintColor = .brown
        
        $0.titleTextView.text = titlePlaceHolder
        $0.titleTextView.textColor = .lightGray
    }

    //설명
    private lazy var descriptionTextField = UITextView().then{
        $0.text = descriptionPlaceHolder
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
        
        baseView.titleTextView.rx.textWithBase
            .bind(onNext: {text, textView in
                if text == self.titlePlaceHolder && textView.textColor == .lightGray{
                    VM.titleText.onNext("")
                }else{
                    VM.titleText.onNext(text)
                }
            })
            .disposed(by: bag)
        
        descriptionTextField.rx.textWithBase
            .bind(onNext: {text, textView in
                if text == self.descriptionPlaceHolder && textView.textColor == .lightGray{
                    VM._descriptionText.onNext("")
                }else{
                    VM._descriptionText.onNext(text)
                }
            })
            .disposed(by: bag)
        
        
        baseView.titleTextView.rx.didBeginEditing
            .subscribe(onNext: {
                if self.baseView.titleTextView.text == self.titlePlaceHolder{
                    self.baseView.titleTextView.text = ""
                    self.baseView.titleTextView.textColor = .black
                }
            })
            .disposed(by: bag)
        
        baseView.titleTextView.rx.didEndEditing
            .subscribe(onNext: {
                if self.baseView.titleTextView.text.isEmpty{
                    self.baseView.titleTextView.text = self.titlePlaceHolder
                    self.baseView.titleTextView.textColor = .lightGray
                }
            })
            .disposed(by: bag)


        
        //[설명 텍스트뷰]에 커서를 뒀을 때 발생하는 이벤트
        descriptionTextField.rx.didBeginEditing
            .subscribe(onNext: {
                if self.descriptionTextField.text == self.descriptionPlaceHolder{
                    self.descriptionTextField.text = ""
                    self.descriptionTextField.textColor = .black
                }
            })
            .disposed(by: bag)
        
        //[설명 텍스트뷰]에 커서를 제거했을 때 발생하는 이벤트
        descriptionTextField.rx.didEndEditing
            .subscribe(onNext: {
                if self.descriptionTextField.text.isEmpty{
                    self.descriptionTextField.text = self.descriptionPlaceHolder
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
        contentView.addSubview(baseView)
        
        baseView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        baseView.infoStackView.addArrangedSubview(descriptionTextField)

        descriptionTextField.snp.makeConstraints{
            $0.leading.equalTo(baseView.titleTextView.snp.leading)
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(200)
        }

    }
}


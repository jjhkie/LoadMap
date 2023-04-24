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
    
    //전체 뷰
    private let containserStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    //이모티콘 작성 뷰
    let imageTextView = UITextField().then{
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 40, weight: .bold)
        $0.placeholder = "+"
        $0.textColor = .white
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 20
    }
    
    //제목 작성 뷰
    private let titleTextView = UITextField().then{
        $0.placeholder = "글제목"
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        imageTextView.delegate = self
        
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GoalAddMainCell{
    
    func bind(_ VM: GoalAddViewModel){
        imageTextView.rx.text.orEmpty
            .subscribe(VM.emojiText)
            .disposed(by: bag)

        titleTextView.rx.text.orEmpty
            .subscribe(VM.titleText)
            .disposed(by: bag)
        
        VM.selectedColor
            .subscribe(onNext: {color in
                
                self.imageTextView.backgroundColor = color.uiColor
            })
            .disposed(by: bag)
    }
    

    
    private func layout(){
        [imageTextView,titleTextView].forEach { view in
            containserStackView.addArrangedSubview(view)
        }
        
        
        contentView.addSubview(containserStackView)
        
        containserStackView.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        }
        
        imageTextView.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(imageTextView.snp.width)
        }
    }
}

extension GoalAddMainCell:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text{
            if text.count > 0{
                textField.deleteBackward()
            }
            return true
        }
        print("\(textField.text) ||| \(range) |||| \(string)")
        return true
    }
    
}

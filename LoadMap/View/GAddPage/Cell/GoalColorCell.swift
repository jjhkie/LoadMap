//
//  GoalColorCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/20.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class GoalColorCell:UITableViewCell{
    
    private let bag = DisposeBag()
    
    
    private let emojiLabel = UIImageView().then{

        $0.image = UIImage(systemName: "sparkles")
        $0.tintColor = .brown
    }
    
    private let containerView = UIStackView().then{
        $0.axis = .vertical
    }
    
    let titleLabel = UILabel().then{
        $0.text = "색상"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    
    private let colorStackView = UIStackView().then{
        $0.axis = .horizontal
    }
    let colorButton = UIColorWell()
    
    let freeView = UIView().then{
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

extension GoalColorCell{
    
    func rgbValue(_ color: UIColor) -> GoalColor{
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        
        let value = GoalColor(red: red, green: green, blue: blue, alpha: alpha)

        return value
    }
    
    func bind(_ VM: GoalAddViewModel){

        let colorObservable = colorButton.rx.controlEvent(.valueChanged)
            .map { [self]_ in
                rgbValue(colorButton.selectedColor!)}
            .asObservable()
        
        colorObservable
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: bag)
        
        colorObservable
            .bind(to: VM.selectedColor)
            .disposed(by: bag)
        
    }
    
    private func layout(){
        
        [emojiLabel,containerView].forEach{
            contentView.addSubview($0)
        }
        
        [colorButton,freeView].forEach{
            colorStackView.addArrangedSubview($0)
        }
        
        [titleLabel,colorStackView].forEach{
            containerView.addArrangedSubview($0)
        }
        
        emojiLabel.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 5, bottom: 0, right: 0))
            $0.height.width.equalTo(20)
        }
        
        containerView.snp.makeConstraints{
            $0.top.equalTo(emojiLabel.snp.top)
            $0.leading.equalTo(emojiLabel.snp.trailing).offset(15)
            $0.trailing.bottom.equalToSuperview()
        }
        

        
    }
}

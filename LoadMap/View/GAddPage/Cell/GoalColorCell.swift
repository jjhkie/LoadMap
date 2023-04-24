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
    
    private let containerView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    let titleLabel = UILabel().then{
        $0.textAlignment = .left
    }
    
    let colorButton = UIColorWell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
//
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//
//        let redValue = Int(red * 255.0)
//        let greenValue = Int(green * 255.0)
//        let blueValue = Int(blue * 255.0)
//        let alphaValue = Int(alpha * 255.0)
        
        let value = GoalColor(red: red, green: green, blue: blue, alpha: alpha)
//        value.redValue = redValue
//        value.blueValue = blueValue
//        value.greenValue = greenValue
//        value.alphaValue = alphaValue
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
        
        [titleLabel,colorButton].forEach{
            containerView.addArrangedSubview($0)
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        }
        
        titleLabel.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.3)
        }
        
    }
}

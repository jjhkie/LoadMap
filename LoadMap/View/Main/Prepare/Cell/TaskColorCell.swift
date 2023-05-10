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

final class TaskColorCell:UITableViewCell{
    
    private let bag = DisposeBag()
    
    private lazy var baseView = BaseView(editEnable: false).then{
        $0.emojiImage.image = Constants.Images.colorImage
        $0.emojiImage.tintColor = .brown
        
        $0.titleTextView.text = "색상"
    }
    
    
    private let colorStackView = UIStackView().then{
        $0.axis = .horizontal
    }
    
    private let colorButton = UIColorWell().then{
        $0.selectedColor = .black
    }
    
    private let freeView = UIView().then{
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

extension TaskColorCell{
    
    func bind(viewmodel VM: TaskAddViewModel){
        
        let colorObservable = colorButton.rx.controlEvent(.valueChanged)
            .map {
                self.colorButton.selectedColor!.rgbValue
            }
            .asObservable()
        
        colorObservable
            .bind(to: VM._selectedColor)
            .disposed(by: bag)
        
    }
    
    private func layout(){
        
        contentView.addSubview(baseView)
        
        baseView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        [colorButton,freeView].forEach{
            colorStackView.addArrangedSubview($0)
        }
        
        baseView.infoStackView.addArrangedSubview(colorStackView)
        
    }
}

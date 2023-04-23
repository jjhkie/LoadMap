//
//  GoalItemCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/20.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class GoalItemCell: UITableViewCell{
    
    let bag = DisposeBag()
    
    private let wrapView = UIStackView().then{
        $0.axis = .vertical
        $0.distribution = .fill
    }
    
    private let containerView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    let titleLabel = UILabel()
    
    let contentTextView = UITextField()
    
    let addButton = UIButton().then{
        $0.backgroundColor = .red
        
    }
    
    var worksData :[String] = []
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GoalItemCell{
    
    func bind(_ VM: GoalAddViewModel){
        
        
        addButton.rx.tap
            .subscribe(onNext: {
                
                if let text = self.contentTextView.text{
                    print(text)
                    let addView = UIButton(type: .system)
                    
                    addView.setTitle(text, for: .normal)
                    self.worksData.append(text)

 
                    VM.workAdd(self.worksData)
                    self.wrapView.addArrangedSubview(addView)
                    addView.snp.makeConstraints{
                        $0.height.equalTo(50)
                    }
                    self.contentTextView.text = ""
                }

                print("abc")
            })
            .disposed(by: bag)
    }
    
    
    private func layout(){
        
        [titleLabel,contentTextView,addButton].forEach{
            containerView.addArrangedSubview($0)
        }
        
        wrapView.addArrangedSubview(containerView)
        
        [wrapView].forEach{
            contentView.addSubview($0)
        }
        containerView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        wrapView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}

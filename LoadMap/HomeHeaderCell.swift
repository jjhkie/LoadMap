//
//  HomeHeaderCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/17.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
class HomeHeaderCell: UITableViewHeaderFooterView{
    
    let emojlabel = UILabel().then{
        $0.font = .systemFont(ofSize: 30, weight: .bold)
        $0.backgroundColor = .red
        $0.layer.cornerRadius = $0.frame.width / 2
    }
    let titleLabel = UILabel()
    
    let viewMore = UIButton().then{
        $0.backgroundColor = .yellow
    }
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        bind()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeHeaderCell{
    
    func bind(){
        viewMore.rx.tap
            .bind(onNext: {
                print("abc")
            })
            .disposed(by: DisposeBag())
    }
    
    private func layout(){
        [emojlabel,titleLabel,viewMore].forEach{
            contentView.addSubview($0)
        }
        
        emojlabel.snp.makeConstraints{
            $0.top.leading.bottom.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(emojlabel.snp.top)
            $0.leading.equalTo(emojlabel.snp.trailing)
        }
        
        viewMore.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.equalTo(emojlabel.snp.bottom)
        }
    }
}

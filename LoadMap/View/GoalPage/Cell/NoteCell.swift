//
//  NoteCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/18.
//

import UIKit
import SnapKit


class NoteCell: UITableViewCell{
    
    //상단 시간 출력 뷰
    let dateLabel = UILabel()
    
    //Note 내용 출력 뷰
    let textView = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension NoteCell{
    private func layout(){
        
        [dateLabel,textView].forEach{
            contentView.addSubview($0)
        }
        
        dateLabel.snp.makeConstraints{
            $0.leading.top.equalToSuperview()
        }
        
        textView.snp.makeConstraints{
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            
        }
        
    }
}

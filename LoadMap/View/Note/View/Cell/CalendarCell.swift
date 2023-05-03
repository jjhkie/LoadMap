//
//  CalendarCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/05/03.
//

import FSCalendar
import UIKit
import SnapKit

final class CalendarCell: FSCalendarCell{
    
    
    let dayLabel = UILabel()
    
    let dayOfWeekLabel = UILabel()
    
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarCell{
    private func layout(){
        [dayOfWeekLabel,dayLabel].forEach{
            
            contentView.addSubview($0)
        }
        dayOfWeekLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        dayLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
}

//
//  GoalDateCell.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/20.
//

import UIKit
import SnapKit
import Then
import FSCalendar
import RxCocoa
import RxSwift



class GoalDateCell: UITableViewCell{
    
    private let containerView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
    }
    
    let titleLabel = UILabel()
    
    
    let calendar = FSCalendar().then{
        $0.allowsMultipleSelection = true
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        print(calendar.selectedDates)
        print(calendar.selectedDate)
        print(calendar.selectedDates.min())
        
        var item = Calendar.current.date(byAdding: .day, value: 1, to: date)
        
        calendar.select(item)
        
        if calendar.selectedDates.count > 1{
            //var dates: [Date] = []
            var dateIterator = calendar.selectedDates.min()
            while dateIterator != calendar.selectedDates.max() {
                //dates.append(dateIterator!)
                dateIterator = Calendar.current.date(byAdding: .day, value: 1, to: dateIterator!)
                calendar.select(dateIterator)
            }
            
        }
        //        if let firstSelectedDate = calendar.selectedDates.first,
        //           let lastSelectedDate = calendar.selectedDates.last {
        //            // 선택된 날짜의 범위를 구합니다.
        //            let fromDate = min(firstSelectedDate, lastSelectedDate)
        //            let toDate = max(firstSelectedDate, lastSelectedDate)
        //            // 범위 내의 날짜들을 전부 선택합니다.
        //            var dates: [Date] = []
        //            var dateIterator = fromDate
        //            while dateIterator <= toDate {
        //                dates.append(dateIterator)
        //                dateIterator = Calendar.current.date(byAdding: .day, value: 1, to: dateIterator)!
        //            }
        //
        //            calendar.select(dates)
        //        }
    }
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //calendar.delegate = self
        layout()
        
   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GoalDateCell{
    
    func bind(){
        
    }
    
    private func layout(){
        [titleLabel,calendar].forEach{
            containerView.addArrangedSubview($0)
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints{
            $0.height.equalTo(60)
        }
        calendar.snp.makeConstraints{
            $0.height.equalTo(titleLabel.snp.height).multipliedBy(4)
        }
    }
}

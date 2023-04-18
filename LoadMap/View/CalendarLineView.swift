//
//  CalendarLineView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/18.
//

import UIKit
import FSCalendar
import SnapKit

class CalendarLineView: UIViewController{
    let calendar = FSCalendar()
    
    var eventsArray = [Date()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        view.backgroundColor = .white
        setCalendarUI()
        calendar.appearance.borderSelectionColor = UIColor.black
        layout()
    }
}

extension CalendarLineView{
    
    func setCalendarUI(){
        self.calendar.locale = Locale(identifier: "ko_KR")
        // 캘린더 스크롤 방향 지정
        self.calendar.scrollDirection = .vertical
        
        // Header dateFormat, 년도, 월 폰트(사이즈)와 색, 가운데 정렬
        self.calendar.appearance.headerDateFormat = "MM월"
        //.calendar.appearance.headerTitleFont = UIFont.SpoqaHanSans(type: .Bold, size: 20)
        self.calendar.appearance.headerTitleColor = UIColor(named: "FFFFFF")?.withAlphaComponent(0.9)
        self.calendar.appearance.headerTitleAlignment = .center
        
        // 요일 글자 색
        self.calendar.appearance.weekdayTextColor = UIColor(named: "F5F5F5")?.withAlphaComponent(0.2)
        // 캘린더 높이 지정
        self.calendar.headerHeight = 60
        // 캘린더의 cornerRadius 지정
        self.calendar.layer.cornerRadius = 10
        
        // 달에 유효하지 않은 날짜의 색 지정
                self.calendar.appearance.titlePlaceholderColor = UIColor.white.withAlphaComponent(0)
        
        // 날짜 색
                self.calendar.appearance.titleDefaultColor = UIColor.black.withAlphaComponent(0.5)
        // 달에 유효하지않은 날짜 지우기
                //self.calendar.placeholderType = .none
        
        // 캘린더 숫자와 subtitle간의 간격 조정
                self.calendar.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
        
    }
    
    private func layout(){
        view.addSubview(calendar)
        
        calendar.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
extension CalendarLineView: FSCalendarDataSource{
       // 이벤트 밑에 Dot 표시 개수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        print(date)
        if self.eventsArray.contains(date){
            return 1
        }
//        if self.eventsArray_Done.contains(date){
//            return 1
//        }

        return 1
    }
    
    // Selected Event Dot 색상 분기처리 - FSCalendarDelegateAppearance
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        if self.eventsArray.contains(date){
            return [UIColor.green]
        }

//        if self.eventsArray_Done.contains(date){
//            return [UIColor.red]
//        }

        return [UIColor.red]
    }
    
    // Default Event Dot 색상 분기처리 - FSCalendarDelegateAppearance
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]?{
        if self.eventsArray.contains(date){
            return [UIColor.green]
        }

//        if self.eventsArray_Done.contains(date){
//            return [UIColor.red]
//        }

        return [UIColor.red]
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let eventScaleFactor: CGFloat = 1.8
        cell.eventIndicator.transform = CGAffineTransform(scaleX: cell.frame.width, y: eventScaleFactor)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
            return CGPoint(x: 0, y: 3)
        }
}

extension CalendarLineView: FSCalendarDelegate,FSCalendarDelegateAppearance{
    


    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        let selectedDate = Date()
        if date == selectedDate {
            return UIColor.black // 줄의 색상
        } else {
            return nil
        }
    }
    
    // 날짜의 글씨 자체를 오늘로 바꾸기
      func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
          switch date {
          case Date():
              return "오늘"
          default:
              return nil
          }
      }
}

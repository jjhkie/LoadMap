//
//  CalendarLineView.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/18.
//

import UIKit
import FSCalendar
import SnapKit
import Then
import RxCocoa
import RxSwift

class CalendarLineView: UIViewController{
    
    let viewmodel = CalendarLineViewModel()
    
    private let bag = DisposeBag()
    
    
    //캘린더
    let calendar = FSCalendar().then{
        $0.register(FSCalendarCell.self, forCellReuseIdentifier: "Cell")
        $0.scope = .month
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.headerHeight = 50
        $0.weekdayHeight = 30
    }
    
    //하단 테이블뷰
    let tableView = UITableView().then{
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        $0.backgroundColor = .red
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //제스처 인식
    lazy var scopeGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:))).then{

        $0.delegate = self
        $0.minimumNumberOfTouches = 1
        $0.maximumNumberOfTouches = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //1
        self.view.addGestureRecognizer(self.scopeGesture)
        //- view에 GestureRecognizer를 추가한다.
        //- view에서 사용자가 발생시키는 터치 이벤트를 처리할 수 있다.

        
        //테이블뷰의 panGesture가 scopeGesture보다 우선되지 않도록 설정한다.
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        //tableView.dataSource = self
        calendar.delegate = self
        calendar.dataSource = self
        view.backgroundColor = .white
        setCalendarUI()
        bind(viewmodel)
        calendar.appearance.borderSelectionColor = UIColor.black
        layout()
    }
}

//MARK: - Gesture Delegate

extension CalendarLineView:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
             if shouldBegin {
                 let velocity = self.scopeGesture.velocity(in: self.view)
                 switch self.calendar.scope {
                 case .month:
                     return velocity.y < 0
                 case .week:
                     return velocity.y > 0
                 }
             }
             return shouldBegin
    }
}

//MARK: - Layout
extension CalendarLineView{
    
    func setCalendarUI(){
        
        self.calendar.locale = Locale(identifier: "ko_KR")
        // 캘린더 스크롤 방향 지정
        self.calendar.scrollDirection = .horizontal
        
        // Header dateFormat, 년도, 월 폰트(사이즈)와 색, 가운데 정렬
        self.calendar.appearance.headerDateFormat = "MM월"
        //.calendar.appearance.headerTitleFont = UIFont.SpoqaHanSans(type: .Bold, size: 20)
        self.calendar.appearance.headerTitleColor = UIColor(named: "FFFFFF")?.withAlphaComponent(0.9)
        self.calendar.appearance.headerTitleAlignment = .center
        
        // 요일 글자 색
        self.calendar.appearance.weekdayTextColor = UIColor(named: "F5F5F5")?.withAlphaComponent(0.2)
        // 캘린더 높이 지정
        self.calendar.headerHeight = 30
        self.calendar.weekdayHeight = 10
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
    
    func bind(_ VM: CalendarLineViewModel){
        let input = CalendarLineViewModel.Input()
        let output = VM.inOut(input: input)
        
        
        output.cellData
            .drive(tableView.rx.items(cellIdentifier: "tableCell",cellType: UITableViewCell.self)){row,data,cell in
                cell.textLabel?.text = "\(data.endDay)"
               
                
            }
            .disposed(by: bag)
    }
    
    private func layout(){
        [calendar,tableView].forEach{
            view.addSubview($0)
        }
        
        calendar.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.height.equalTo(UIScreen.main.bounds.height * 0.5)
            //calendarHeihtConstraint = $0.height.equalToSuperview().constraint
        }
        tableView.snp.makeConstraints{
            $0.top.equalTo(calendar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            
        }
    }
}

//MARK: - Clendar DataSource

extension CalendarLineView: FSCalendarDataSource{
    
   
    //MARK: minimumDate
    //달력에서 선택 가능한 최소 날짜 설정
    //설정한 날짜가 2023년 1월 1일이라면
    //설정한 날짜 이전의 달력은 볼 수 없다.
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        guard let displayminimumDay = formatter.date(from: "2020.01.01") else { return Date() }
//        return displayminimumDay
//    }
    
    //MARK: MaximumDate
    //달력에서 선택 가능한 최대 날짜 선정
    //설정한 날짜까지만 달력에서 보인다.
//    func maximumDate(for calendar: FSCalendar) -> Date {
//        guard let displayminimumDay = formatter.date(from: "2040.12.31") else { return Date() }
//        return displayminimumDay
//    }
    
    //MARK: cellFor
    //달력의 셀을 구성하고 커스터마이징 한다.
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        let cell = calendar.dequeueReusableCell(withIdentifier: "Cell", for: date, at: position) as FSCalendarCell
        
        //Foundation 에서 제공하는 Calendar
        let today = Calendar.current

        let components = today.dateComponents([.day], from: date)
        
        //1이 포함된 일의 셀의 배경색을 변경한다.
//        if components.day == 1{
//            cell.backgroundColor = .black
//        }
        
        return cell
    }
    
    //MARK: numberOfEventsFor
    //해당 날짜의 이벤트의 개수를 확인할 수 있다.
    // 이벤트 밑에 Dot 표시 개수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        print(date.koreanTime)
        return viewmodel.objectData.filter{
            
            return  $0.startDay <= date.koreanTime && $0.endDay >= date.koreanTime
            
        }.count
    }
}

//MARK: - FSCalendar Delegate
extension CalendarLineView: FSCalendarDelegate,FSCalendarDelegateAppearance{
    
    //MARK:  WillDsiplayCell
    //달력 셀이 화면에 표시될 때 호출되는 메서드
    //셀의 추가적인 작업을 수행 가능
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
//        let eventScaleFactor: CGFloat = 1.8
//        cell.eventIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
    }
    
    //MARK: CalendarCurrentPageDidChange
    //달력의 현재 페이지가 변경될 때 호출되는 메서드
    // 달력 페이지가 변경될 때 추가적인 작업 수행 가능
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = calendar.currentPage

      
          
       
    }
    func calendar(_ calendar: FSCalendar, weekdayView weekday: UIView, weekdayTextAlignmentFor date: Date) -> NSTextAlignment {
        return .center // 요일 텍스트 중앙 정렬
    }
    //MARK: - ShouldSelect
    //특정 날짜를 선택할 때 호출되는 메서드
    // 사용자가 특정 날짜를 선택할 수 있는지 여부를 결정할 수 있다.
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let today = Date()
        if date < today{
            //현재 날짜 이전의 날짜는 선택할 수 없도록 설정
            return false
        }else{
            return true
        }
    }
    
    //MARK:  DidSelectDate
    //특정 날짜를 선택했을 때 호출되는 메서드
    //특정 날짜를 선택했을 때 어떤 작업을 수행할 지 설정
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewmodel.dateObservable.onNext(date.koreanTime)
        print(date.koreanTime)
        tableView.reloadData()
        
    }
    
    
    
    //MARK:  ShouldDeselectDate
    //특정 날짜의 선택을 해제할 때 호출되는 메서드
    // 사용자가 선택한 날짜의 선택을 해제할 수 있는지 여부를 결정
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        false
    }
    
    //MARK:  DidDeselectDate
    //특정 날짜의 선택이 해제되었을 때 호출되는 메서드
    //선택이 해제되었을 때 어떤 작업을 수행할 지 설정
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
    }
    
    //MARK:  BoundingRectWillChange
    //달력의 크기가 변경될 때 호출되는 메서드
    //달력의 크기가 변경될 때 애니메이션 구현 가능
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        self.calendar.snp.updateConstraints { make in
                make.height.equalTo(bounds.height)
            }
            
            view.layoutIfNeeded()
    }
    
    //MARK:  FillDefaultColorForDate
    //기본 배경 색상을 설정하는 메서드
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let calendar = Calendar.current
         let components = calendar.dateComponents([.year, .month, .day], from: date)
         if components.day == 1 {
             return UIColor.green
         } else {
             return nil
         }
    }

    //MARK:  FillSelectionColorFor
    //날짜가 선택될 때 적용되는 배경색 설정하는 메서드
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        //선택된 날짜가 토요일,일요일일 경우 빨간색으로 배경색 설정
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        if weekday == 1 || weekday == 7 {
            return UIColor.red
        } else {
            return nil
        }
    }
    
    //MARK:  TitleDefaultColorFor
    //달력에서 날짜의 기본 텍스트 색상을 설정하는 메서드
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let weekday = Calendar.current.component(.weekday, from: date)
        if weekday == 1 || weekday == 7 {
            return UIColor.red
        } else {
            return nil
        }
    }
    
    //MARK:  TitleSelectionColorForDate
    //달력에서 선택된 날짜의 텍스트의 색상을 설정하는 메서드
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .blue
    }
    
    //MARK:  SubtitleDefaultColorForDate
    //달력에서 부제목의 기본 텍스트 색상을 설정하는 메서드
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        return .brown
    }
    
    //MARK: SubtitleSelectionColorForDate
    
    //MARK: EventDefaultColorsForDate
    //달력에서 날짜에 연관된 이벤트의 기본 색상 배열을 설정
    // Default Event Dot 색상 분기처리 - FSCalendarDelegateAppearance
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]?{
    
        
        //        if self.eventsArray_Done.contains(date){
        //            return [UIColor.red]
        //        }
        
        return [UIColor.red]
    }
    
    
    //MARK:  EventSelectionColorsForDate
    // Selected Event Dot 색상 분기처리 - FSCalendarDelegateAppearance
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
  
        
        //        if self.eventsArray_Done.contains(date){
        //            return [UIColor.red]
        //        }
        
        return [UIColor.red]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        let selectedDate = Date()
        if date == selectedDate {
            return UIColor.green // 줄의 색상
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

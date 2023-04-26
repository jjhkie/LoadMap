//
//  FScalendar+Rx.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/23.
//

import RxCocoa
import RxSwift
import FSCalendar

class RxFSCalendarDelegateProxy: DelegateProxy<FSCalendar, FSCalendarDelegate>, DelegateProxyType, FSCalendarDelegate{
    
   
    //DelegateProxyType 프로토콜은 Delegate 프록시 객체를 정의하고, Delegate 클래스의 구현체를 등록하는 메서드를 정의한다.
    // 해당 메서드는 Delegate 클래스들의 구현체를 등록하는 데 사용됩니다. 등록된 구현체들은 프록시 객체가 처리해야 하는 Delegate 메서드 호출에 사용됩니다.
    static func registerKnownImplementations() {
        self.register{ (calendar) -> RxFSCalendarDelegateProxy in
            RxFSCalendarDelegateProxy(parentObject: calendar, delegateProxy: self)
        }
    }
    //현재 Delegate 클래스의 인스턴스를 반환
    static func currentDelegate(for object: FSCalendar) -> FSCalendarDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: FSCalendarDelegate?, to object: FSCalendar) {
        if let delegate = delegate {
            // delegate 값이 nil이 아닐 때만 delegate 객체를 사용합니다.
            object.delegate = delegate
        }else{
            object.delegate = nil
        }
        
    }
    
    
}

extension Reactive where Base: FSCalendar {
    
    var delegate: RxFSCalendarDelegateProxy {
        return RxFSCalendarDelegateProxy.proxy(for: base)
    }
    
    var dateSelect: ControlEvent<Date> {
        let source =  delegate.methodInvoked(#selector(FSCalendarDelegate.calendar(_:didDeselect:at:)))
            .map {value in
                Date()
            }
        return ControlEvent(events: source)
    }
}

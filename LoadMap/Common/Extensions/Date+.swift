//
//  Date+.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/27.
//

import Foundation


extension Date{
    
    func dateFormatter(_ format: String) -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    var basicFormatter:String{
        return dateFormatter("yyyy.MM.dd")
    }
    
    var dayOfWeekString:String{
        return dateFormatter("EE")
    }
    
    //시간 정수형으로 출력
    var dayOfTime: Int{
        return Int(dateFormatter("HH"))!
    }
    
    var dayOfTimeString:String{
        return dateFormatter("a h시 mm분")
    }

    var dayStringText: String{
        let dateText = formatted(date: .numeric, time: .omitted)
        let timeFormat = NSLocalizedString("%@", comment: "StringDate")
        return String(format: timeFormat, dateText)
    }
    
    func dayBefore() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: .day, value: -1, to: self)!
    }
    
    func nextDay() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: .day, value: 1, to: self)!
    }
    
    var transformComponents: DateComponents{
        let calendar = Calendar.current

        return calendar.dateComponents([.year, .month, .day], from: self)
    }
    
    ///시간을 한국 기준으로
    var koreanTime: Date {
        let timezone = TimeZone(abbreviation: "KST")!
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    /// 시간을 00 시로
    func startOfDay(in timeZone: TimeZone = .current) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = timeZone

       return calendar.startOfDay(for: self)
    }
    
    /// 시간을 23시 59분 59초로
    func endOfDay() -> Date{
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
}

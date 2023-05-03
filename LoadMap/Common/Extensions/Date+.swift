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
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    var basicFormatter:String{
        return dateFormatter("yyyy.MM.dd")
    }
    
    var dayOfWeekString:String{
        return dateFormatter("EE")
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
    
    var koreanTime: Date {
        let timezone = TimeZone(abbreviation: "KST")!
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func startOfDay(in timeZone: TimeZone = .current) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = timeZone

       return calendar.startOfDay(for: self)
    }
    
    
    func endOfDay() -> Date{
        var calendar = Calendar.current
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
}

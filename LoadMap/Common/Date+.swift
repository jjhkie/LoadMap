//
//  Date+.swift
//  LoadMap
//
//  Created by 김진혁 on 2023/04/27.
//

import Foundation


extension Date{
    var dayStringText: String{
        let dateText = formatted(date: .abbreviated, time: .omitted)
        let timeFormat = NSLocalizedString("%@", comment: "Convert Date to String type")
        return String(format: timeFormat, dateText)
    }
}

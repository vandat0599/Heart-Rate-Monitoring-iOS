//
//  Date+.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 1/8/21.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    func fromTimeMilli(timeMilli: String) -> Date{
        return NSDate(timeIntervalSince1970: TimeInterval(Int(timeMilli)!)) as Date
    }
    
    var hour: Int{
        return Calendar.current.component(.hour, from: self)
    }
    var minute: Int{
        return Calendar.current.component(.minute, from: self)
    }
    var second: Int{
        return Calendar.current.component(.second, from: self)
    }
}

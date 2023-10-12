//
//  TimeAgo.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 15.06.2023.
//

import Foundation

struct TimeAgo {
   static func timeAgoDisplay(date: Date) -> String {
       var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en_US")
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -5, to: Date())!
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: Date())!
        
        if minuteAgo < date {
            return "now"
        } else if hourAgo < date {
            let diff = Calendar.current.dateComponents([.minute],
                                                       from: date,
                                                       to: Date()).minute ?? 0
            if diff == 1 {
                return "\(diff) minute ago"
            } else {
                return "\(diff) minute ago"
            }
        } else if dayAgo < date {
            let diff = Calendar.current.dateComponents([.hour],
                                                       from: date,
                                                       to: Date()).hour ?? 0
            if diff == 1 {
                return "\(diff) hour ago"
            } else {
                return "\(diff) hour ago"
            }
        } else if weekAgo < date {
            let diff = Calendar.current.dateComponents([.day],
                                                       from: date,
                                                       to: Date()).day ?? 0
            if diff == 1 {
                return "\(diff) day ago"
            } else {
                return "\(diff) day ago"
            }
        } else if monthAgo < date {
            return date.getString(format: .dayAndMonth)
        }
        return date.getString(format: .dayMonthYear)
    }
}

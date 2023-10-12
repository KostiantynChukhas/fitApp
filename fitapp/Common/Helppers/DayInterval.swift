//
//  DayInterval.swift
//  fitapp
//
//  on 11.05.2023.
//

import Foundation

class DayInterval {
    
    static func getDayInterval() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())

        var period: String

        switch hour {
        case 0..<6:
            period = "Night"
        case 6..<12:
            period = "Morning"
        case 12..<18:
            period = "Afternoon"
        default:
            period = "Evening"
        }
        return period
    }
}

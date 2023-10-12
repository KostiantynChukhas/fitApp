//
//  Date+Extra.swift
//  Extensions//

import Foundation

public extension Date {
    func isInSameDayOf(date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }

    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }

    func wasYesterday() -> Bool {
        return Calendar.current.isDateInYesterday(self)
    }
}

func convertStringToDate(_ dateString: String, fromFormat dateFormat: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.date(from: dateString)
}

func formatDate(_ date: Date, toFormat dateFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.string(from: date)
}

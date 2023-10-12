//
//  DateFormatter.swift
//  fitapp
//
//  on 23.05.2023.
//

import Foundation

extension Date {
    func timeIntervalSince1970String() -> String {
        return String(format: "%.0f", self.timeIntervalSince1970)
    }
}

extension DateFormatter {
    static func dateFromString(_ dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }
}

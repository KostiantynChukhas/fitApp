//
//  Int+String.swift
//  Extensions//

import Foundation

public extension Int {
    func formatted(format: String) -> String {
        return String(format: format, self)
    }
    
    func createTimeString() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        let hoursString = hours < 10 ? "0\(hours)" : "\(hours)"
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
    
    func createMinutesString() -> String {
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        return "\(minutesString):\(secondsString)"
    }
}

//
//  Double+String.swift
//  Extensions//
//

import Foundation

public extension Double {
    func formatted(format: String) -> String {
        return String(format: format, self)
    }
}

public extension Double {
    private var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }

    private var seconds: Int {
        return Int(self) % 60
    }

    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }

    private var hours: Int {
        return Int(self) / 3600
    }

    var playerTimeString: String {
        let resultText: String
        
        if hours <= 0 {
            resultText = minutes.formatted(format: "%d") + ":" + seconds.formatted(format: "%02d")
        } else {
            resultText = hours.formatted(format: "%d") + minutes.formatted(format: "%02d") + ":" + seconds.formatted(format: "%02d")
        }
        return resultText
    }
}


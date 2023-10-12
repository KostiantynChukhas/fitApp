//
//  Date.swift
//  fitapp
//
// on 05.05.2023.
//

import UIKit
extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func timeAgo() -> String {
           let formatter = DateComponentsFormatter()
           formatter.unitsStyle = .full
           formatter.maximumUnitCount = 1
           formatter.includesApproximationPhrase = true
           formatter.includesTimeRemainingPhrase = false
        
           if let timeAgo = formatter.string(from: self, to: Date()) {
               return timeAgo
           } else {
               return "Unknown"
           }
       }
}



//
//  NotificationCellViewModel.swift
//  fitapp
//
//  Created by  on 23.07.2023.
//

import UIKit
import RxSwift
import RxDataSources

struct NotificationCellViewModel: Equatable, Hashable, IdentifiableType {
    let id: Int
    let type: NotificationType
    let title: String
    
    var identity: Int {
        return id
    }
}

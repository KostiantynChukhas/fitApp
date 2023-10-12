//
//  SegmentItem.swift
//  fitapp
//
//  Created by on 25.05.2023.
//

import UIKit

struct SegmentItem {
    let segmentVC: UIViewController
    let segmentType: SegmentItemType
}

enum SegmentItemType: CaseIterable {
    case photos
    case aboutMe
    case feed
    case articles
    case reviews
    case measurment
    
    var title: String {
        switch self {
        case .photos:
            return "Photos"
        case .aboutMe:
            return "About me"
        case .feed:
            return "Feed"
        case .articles:
            return "Articles"
        case .reviews:
            return "Reviews"
        case .measurment:
            return "Measurment"
        }
    }
    
    static var trainerItems: [SegmentItemType] = [.photos, .aboutMe, .reviews]
    
    // TODO: - add measurements
    static var userProfileItems: [SegmentItemType] = [.photos, .aboutMe, .feed]
    
    static var ownProfileItems: [SegmentItemType] = [.photos, .aboutMe, .feed, .articles]
    
}


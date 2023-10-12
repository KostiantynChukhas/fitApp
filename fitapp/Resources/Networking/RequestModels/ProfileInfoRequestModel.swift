//
//  ProfileInfoRequestModel.swift
//  fitapp
//
//  on 23.05.2023.
//

import Foundation

struct ProfileInfoRequestModel: Codable {
    let country: String?
    let city: String?
    let gym: String?
    let experience: String?
    let my_goal: String?
    let short_story: String?
    let about_me: String?
    let achievements: String?
    let education: String?
    let other: String?
    let gender: String?
    let date_birth: String?
    let name: String?
    let notification_workout: Bool?
    let notification_comments: Bool?
    let type_account: String?
    let type_metric_system: String?

    init(country: String? = nil,
         city: String? = nil,
         gym: String? = nil,
         experience: String? = nil,
         my_goal: String? = nil,
         short_story: String? = nil,
         about_me: String? = nil,
         achievements: String? = nil,
         education: String? = nil,
         other: String? = nil,
         gender: String? = nil,
         date_birth: String? = nil,
         name: String? = nil,
         notification_workout: Bool? = nil,
         notification_comments: Bool? = nil,
         type_account: String? = nil,
         type_metric_system: String? = nil) {
        
        self.country = country
        self.city = city
        self.gym = gym
        self.experience = experience
        self.my_goal = my_goal
        self.short_story = short_story
        self.about_me = about_me
        self.achievements = achievements
        self.education = education
        self.other = other
        self.gender = gender
        self.date_birth = date_birth
        self.name = name
        self.notification_workout = notification_workout
        self.notification_comments = notification_comments
        self.type_account = type_account
        self.type_metric_system = type_metric_system
    }
}

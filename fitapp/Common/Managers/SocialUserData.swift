//
//  SocialUserData.swift
//  fitapp
//
// on 04.05.2023.
//

import Foundation
import FirebaseAuth

struct AuthSocialUserData {
    let email: String
    let name: String
    let picture: String
    let providerId: String
    var accessToken: String
    let emailVerified: Bool
    let uid: String
}

class SocialUserData {
    static func getUserData(data: AuthDataResult?, completion: @escaping ((String) -> Void)) {
        if let authResult = data {
            // Get the user's email
            let email = authResult.user.email
            // Get the user's display name
            let name = authResult.user.displayName
            // Get the user's profile photo URL
            let picture = authResult.user.photoURL?.absoluteString
            // Get the user's provider ID (e.g. "google.com")
            let providerId = authResult.additionalUserInfo?.providerID
            // Get the user's ID token
            authResult.user.getIDToken { token, error in
                completion(token ?? "")
            }
            // Get whether the user's email has been verified
            let emailVerified = authResult.user.isEmailVerified
            // Get the user's unique ID
            let uid = authResult.user.uid
        }
        completion("")
    }
}

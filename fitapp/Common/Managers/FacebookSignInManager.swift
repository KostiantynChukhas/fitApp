//
//  FacebookSignInManager.swift
//  fitapp
//

import Foundation
import Firebase
import FBSDKLoginKit

class FacebookSignInManager: NSObject {
    
    static let shared = FacebookSignInManager()
    
    private let loginManager = LoginManager()
    private let auth = Auth.auth()
    
    func signIn(completion: @escaping (String?) -> Void) {
        loginManager.logIn(permissions: ["email", "public_profile"], from: nil) { [weak self] (result, error) in
            guard let self = self else { return }
            
            if let error = error {
                completion(nil)
                return
            }
            
            guard let accessToken = AccessToken.current else {
                let error = NSError(domain: "com.yourapp.FacebookSignInManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get Facebook access token."])
                completion(nil)
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            self.auth.signIn(with: credential) { (authResult, error) in
                if let error = error {
                    completion(nil)
                    return
                }
                
                guard let authResult = authResult else {
                    let error = NSError(domain: "com.yourapp.FacebookSignInManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to sign in with Facebook."])
                    completion("")
                    return
                }
                SocialUserData.getUserData(data: authResult, completion: { token in
                    completion(token)
                })
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
            loginManager.logOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

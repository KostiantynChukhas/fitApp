//
//  GoogleSignInManager.swift
//  fitapp
//
import UIKit
import GoogleSignIn
import Firebase
import AuthenticationServices
import FirebaseAuth

class GoogleSignInManager: NSObject {
    
    static let shared = GoogleSignInManager()
    
    private override init() {
        super.init()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func signIn(completion: @escaping (String?) -> Void) {
        GIDSignIn.sharedInstance().presentingViewController = UIApplication.shared.windows.first?.rootViewController
        GIDSignIn.sharedInstance().signIn()
        self.completion = completion // Store the completion handler for later use
    }
    
    func signOut() {
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
            GIDSignIn.sharedInstance().signOut()
        }
    
    private var completion: ((String?) -> Void)? = nil
    
}

extension GoogleSignInManager: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Google Sign In error: \(error.localizedDescription)")
            completion?("") // Call the completion handler with a `false` value indicating failed login
            return
        }
        
        guard let authentication = user.authentication else {
            print("Missing authentication object for Google user")
            completion?("") // Call the completion handler with a `false` value indicating failed login
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Firebase Sign In error: \(error.localizedDescription)")
                self.completion?("") // Call the completion handler with a `false` value indicating failed login
                return
            }
            print("Firebase Sign In success!")
            SocialUserData.getUserData(data: authResult, completion: { [weak self] token in
                self?.completion?(token)
            })
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google user disconnected")
        // Perform any additional cleanup after the user disconnects from Google
    }
    
}

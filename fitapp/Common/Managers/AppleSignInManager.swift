//
//  AppleSignInManager.swift
//  fitapp
//

import Foundation
import AuthenticationServices
import FirebaseAuth
import CryptoKit

class AppleSignInManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    var authState: String = ""
    private var completion: ((String?) -> Void)? = nil
    
    func handleAuthorizationAppleID(completion: @escaping (String?) -> Void) {
        let nonce = randomNonceString()
        authState = nonce
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        self.completion = completion
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let idToken = credential.identityToken, let appleIDTokenString = String(data: idToken, encoding: .utf8) else {
                print("Failed to retrieve the idToken and nonce from Apple ID credential.")
                completion?("")
                return
            }
            
            let nonce = authState
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: appleIDTokenString, rawNonce: sha256(nonce))
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Failed to authenticate with Firebase: \(error.localizedDescription)")
                    self.completion?("")
                    return
                }
                // Store user data in Firebase database
                SocialUserData.getUserData(data: authResult) { [weak self] token in
                    self?.completion?(token)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple sign in failed: \(error.localizedDescription)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            fatalError("Unable to retrieve key window for authorization controller")
        }
        return window
    }
    
    // MARK: - Helper methods
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}

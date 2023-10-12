//
//  UploadProfileImageRequestModel.swift
//  fitapp
//
//  on 23.05.2023.
//

import Foundation

class UploadProfileImageRequestModel: Codable {
    let picture: Data
    
    init(picture: Data) {
        self.picture = picture
    }
    
    init(dictionary: [String: Any]) {
           self.picture = dictionary["picture"] as? Data ?? Data()
        
    }
}

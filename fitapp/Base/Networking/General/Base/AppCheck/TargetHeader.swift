//
//  TargetHeader.swift
//  Networking
//

import Foundation
import Moya
import Alamofire

public struct TargetHeader: TargetType {
    let endPoint: TargetType
    public let appCheckToken: String
    public init(endPoint: TargetType, appCheckToken: String) {
        self.endPoint = endPoint
        self.appCheckToken = appCheckToken
    }
}

public extension TargetHeader {

    var baseURL: URL { endPoint.baseURL }
    
    var path: String { endPoint.path }
    
    var method: Moya.Method { endPoint.method }
    
    var task: Moya.Task { endPoint.task }
    
    var headers: [String : String]? {
        let info = Bundle.main.infoDictionary
        let appVersion = info?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let appBuild = info?["CFBundleVersion"] as? String ?? "Unknown"
        var headers = endPoint.headers
        headers?["platform"] = "ios"
        headers?["Version"] = appVersion
        headers?["Version-Code"] = appBuild
        headers?["X-Firebase-AppCheck"] = appCheckToken
        return headers
    }
}

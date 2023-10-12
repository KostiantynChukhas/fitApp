//
//  Defines.swift
//  fitapp
//

import Foundation
import UIKit

typealias EmptyClosureType = () -> ()
typealias SimpleClosure<T> = (T) -> ()


class Defines {
    static let baseEndpoint: String = "https://fitncrazy.pro"
    
    static let loginEndpoint: String = "\(baseEndpoint)/auth/login/"
    static let registrationEndpoint: String = "\(baseEndpoint)/auth/register/"
    static let infoOnboardEdit: String = "\(baseEndpoint)/account/info-onboard-edit"
    //Library
    static let getLibrary: String = "\(baseEndpoint)/library/"

    
//    static let paypalClientId = "AVTWozovjRxDV-6PUaVuL2UXeB9gE5sh5LTL-sgEeIx6SE2GBwU159JY8WB95ZwNb5yRYNbhpncDXhJD"

}

enum URLTypes: String {
    case confirm = "confirm"
    case receiving = "receive"
    case resetPassword = "resetPassword"
}


struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_IPHONE_SIMULATOR != 0 // simulator
        //return TARGET_IPHONE_SIMULATOR != 0 // device
    }
    
    static var isIPad: Bool {
        return UIScreen.main.traitCollection.userInterfaceIdiom == .pad
    }
    
    static var isIphone5Size: Bool {
        return UIScreen.main.nativeBounds.width == 640.0
    }
    
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    static var deviceOrientation: UIInterfaceOrientation {
        return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .portrait
    }
}

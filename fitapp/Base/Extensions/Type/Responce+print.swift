//
//  Responce+print.swift//

import Foundation
import Moya

public extension Response {
    func printResponse() {
        let str = String(decoding: self.data, as: UTF8.self)
//        Swift.print("\n[URL]: \(String(describing: self.request?.url))\n[DATA]: \(str)")
    }
}

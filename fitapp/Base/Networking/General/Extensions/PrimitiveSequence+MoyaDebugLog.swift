//
//  PrimitiveSequence+MoyaDebugLog.swift
//  Core
//

import Foundation
import Moya
import RxSwift

public extension PrimitiveSequence where Trait == SingleTrait {
    /// Print network error
    func printNetworkError() -> Single<Element> {
        catchError { error in
            #if DEBUG
                DispatchQueue.main.async {
                    print(error: error)
                }
            #endif
            return .error(error)
        }
    }
}

// MARK: - Private Functions

#if DEBUG

    private func print(error: Error) {
        print("⛔️⛔️⛔️⛔️ NETWORK ERROR: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")

        var moyaResponse: Response?
        var additionalError: Error?
        var additionalInfo: String?

        if let error = error as? MoyaError {
            tryExtractAdditionalInfo(
                fromMoyaError: error,
                intoAdditionalError: &additionalError,
                intoAdditionalInfo: &additionalInfo,
                intoMoyaResponse: &moyaResponse
            )
        }

        if let urlRequest = moyaResponse?.request {
            print(urlRequest: urlRequest)
        }

        if let moyaResponse = moyaResponse {
            print(moyaResponse: moyaResponse)
        }

        print("⛔️ MAIN ERROR LOCALISED DESCRIPTION: \(error.localizedDescription)")
        print("⛔️ MAIN ERROR DEBUG DESCRIPTION: \(error)")

        if let additionalError = additionalError {
            print("⛔️ ADDITIONAL ERROR LOCALISED DESCRIPTION: \(additionalError.localizedDescription)")
            print("⛔️ ADDITIONAL ERROR DEBUG DESCRIPTION: \(error)")
        }

        if let additionalInfo = additionalInfo {
            print("⛔️ ADDITIONAL INFO: \(additionalInfo)")
        }

        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    }

    private func print(urlRequest request: URLRequest) {
        print("\nREQUEST:")

        print("URL: \(request.url?.absoluteString ?? "")")
        print("METHOD: \(request.method?.rawValue ?? "")")
        print("HEADERS: \(request.headers)")

        if
            let body = request.httpBody,
            let jsonObject = try? JSONSerialization.jsonObject(
                with: body,
                options: []
            )
        {
            var dataPresentation = "\(jsonObject)"

            if
                let jsonFormat = jsonObject as? [AnyHashable: Any],
                let prettyFormat = prettyJsonFormat(json: jsonFormat)
            {
                dataPresentation = prettyFormat
            }
            print("\nREQUEST DATA: \(dataPresentation)")
        }
    }

    private func print(moyaResponse: Response) {
        print("\n\nRESPONSE:")
        print("RESPONSE CODE: \(moyaResponse.statusCode)")

        if let json = try? JSONSerialization.jsonObject(
            with: moyaResponse.data,
            options: []
        ) {
            var dataPresentation = "\(json)"

            if
                let jsonFormat = json as? [AnyHashable: Any],
                let prettyFormat = prettyJsonFormat(json: jsonFormat)
            {
                dataPresentation = prettyFormat
            }
            print("\n RESPONSE DATA: \(dataPresentation)")
        }
        print("\n\n")
    }

    private func tryExtractAdditionalInfo(
        fromMoyaError error: MoyaError,
        intoAdditionalError additionalError: inout Error?,
        intoAdditionalInfo additionalInfo: inout String?,
        intoMoyaResponse moyaResponse: inout Response?
    ) {
        switch error {
        case let .imageMapping(response):
            moyaResponse = response

        case let .jsonMapping(response):
            moyaResponse = response

        case let .stringMapping(response):
            moyaResponse = response

        case let .objectMapping(mappingError, response):
            moyaResponse = response
            additionalError = mappingError

        case let .encodableMapping(encodableError):
            additionalError = encodableError

        case let .statusCode(response):
            moyaResponse = response

        case let .underlying(error, response):
            moyaResponse = response
            additionalError = error

        case let .requestMapping(text):
            additionalInfo = "requestMapping \(text)"

        case let .parameterEncoding(error):
            additionalError = error
        }
    }

    private func prettyJsonFormat(json: [AnyHashable: Any]) -> String? {
        let decodedString = convertToCirilicString(json: json)
        guard
            let jsonData = try? JSONSerialization.data(withJSONObject: decodedString, options: .prettyPrinted),
            let prettyJson = String(data: jsonData, encoding: .utf8)
        else {
            return nil
        }
        return prettyJson
    }

    private extension String {
        var decodingUnicodeCharacters: String {
            let wIvalue = NSMutableString(string: self)
            CFStringTransform(wIvalue, UnsafeMutablePointer<CFRange>(nil), "Any-Hex/Java" as CFString, true)
            return wIvalue as String
        }
    }

    private func convertToCirilicString(json: [AnyHashable: Any]) -> [AnyHashable: Any] {
        var result: [AnyHashable: Any] = [:]
        json.forEach { key, value in
            let anyValue: Any
            if let stringValue = value as? String {
                anyValue = stringValue.decodingUnicodeCharacters
            } else if let stringArray = value as? [String] {
                anyValue = stringArray.map { $0.decodingUnicodeCharacters }
            } else if let jsonValue = value as? [String: Any] {
                anyValue = convertToCirilicString(json: jsonValue)
            } else {
                anyValue = value
            }

            result[key] = anyValue
        }
        return result
    }

#endif

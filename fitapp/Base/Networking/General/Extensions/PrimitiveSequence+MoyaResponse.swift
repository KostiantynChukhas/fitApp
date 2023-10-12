//
//  PrimitiveSequence+MoyaResponse.swift
//  Networking
//

import Foundation
import Moya
import RxSwift

public extension PrimitiveSequence where Trait == SingleTrait {
    /// A check is made to see if the request was successful.
    /// If the server returns an error, then the sequence emits a server error
    func checkServerError() -> Single<Element> where Element: ResponseBaseModelsProtocol {
        asObservable()
            .flatMapFirst { responseModel -> Observable<Element> in

                if responseModel.serverStatusCode == 401 {
                    NotificationCenter.default.post(
                        name: Notification.Name(rawValue: "io.fitapp.ios.Notification.Name.Session.expired"),
                        object: nil
                    )
                }
                guard let error = responseModel.error else {
                    return .just(responseModel)
                }
                let resultError = NetworkError.serverError(error: error, serverMessage: responseModel.message)
                return .error(resultError)
            }
            .asSingle()
    }

    /// Try to extract data from DataResponseBaseModel. If DataResponseBaseModel contains count info this value also passing
    func extractDataOrSendError<T>() -> Single<DataArrayModel<T>>
        where Element: DataResponseBaseModel<T>, T: Decodable, T: Equatable
    {
        return asObservable()
            .flatMap { response -> Observable<DataArrayModel<T>> in
                guard let data = response.data else {
                    return .error(NetworkError.dataMissed)
                }
                let model = DataArrayModel(data: data, count: response.count)
                return .just(model)
            }
            .asSingle()
    }

    func extractErrorWitResponse() -> Single<Element> where Element: ResponseBaseModelsProtocol {
        asObservable()
            .flatMapFirst { responseModel -> Observable<Element> in
                guard let error = responseModel.error else {
                    return .just(responseModel)
                }
                let resultError = NetworkErrorWithData<Any>.serverError(
                    error: error,
                    serverMessage: responseModel.message,
                    data: responseModel
                )
                return .error(resultError)
            }
            .asSingle()
    }
}

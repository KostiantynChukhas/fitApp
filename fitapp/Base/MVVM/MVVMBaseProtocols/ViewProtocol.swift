//
//  ViewProtocol.swift
//  MVVM
//

import Foundation

public protocol ViewProtocol {
    associatedtype ViewModelType: ViewModelProtocol

    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewModel: ViewModelType! { get set }

    func setupOutput()
    func setupInput(input: ViewModelType.Output)
}

//
//  ViewModelProtocol.swift
//  MVVM
//

import Foundation

public protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input, outputHandler: @escaping (_ output: Output) -> Void)
}

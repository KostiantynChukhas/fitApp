//
//  Publisher.swift
//  
//
//  Created by  on 9/16/20.
//  Copyright © 2020 Nikola Milic. All rights reserved.
//

import RxSwift
import RxCocoa

public final class Publisher<Element>: ObserverType {
    /// Notify observer about sequence event.
    ///
    /// - parameter event: Event that occured.
    public func on(_ event: Event<Element>) {
        switch event {
        case let .next(element):
            publish(element)
        default: ()
        }
    }
    
    public typealias E = Element
    
    private let _subject: PublishSubject<Element>
    
    public func publish(_ event: E) {
        _subject.onNext(event)
    }
    
    /// Initializes variable with initial value.
    public init() {
        _subject = PublishSubject()
    }
    
    /// - returns: Canonical interface for push style sequence
    public func asObservable() -> Observable<E> {
        return _subject.subscribe(on: MainScheduler.instance)
    }
    
    public func asDriver() -> Driver<E> {
        return _subject.asDriver(onErrorRecover: { _ in .never() })
    }
    
    deinit {
        _subject.on(.completed)
    }
}


//
//  Pagination.swift
//  Pagination
//
import Foundation
import RxCocoa
import RxSwift

public final class Pagination<PaginationDependency: PaginationDependencyType, Element> {
    // MARK: - Typealias

    internal typealias PageContext = Page<PaginationDependency, Element>
    internal typealias PaginationStateContext = PaginationState<PaginationDependency, Element>
    // swiftlint:disable:next line_length
    public typealias PageProviderClosure = (PaginationDependency) -> Single<PaginationPageElement<PaginationDependency, Element>>

    // MARK: - Constructor

    public init() {}

    // MARK: - Functions

    public func makeState(
        refreshSignal: Observable<Void>,
        loadNextSignal: Observable<Void>,
        initialDependencyProvider: @escaping () -> PaginationDependency,
        pageProvider: @escaping PageProviderClosure
    ) -> Observable<PageState<Element>> {
        refreshSignal
            .map { _ in initialDependencyProvider() }
            .startWith(initialDependencyProvider())
            .flatMapLatest { initialDependency -> Observable<PaginationStateContext> in
                Observable.paginationSystem(
                    scheduler: SerialDispatchQueueScheduler(qos: .userInteractive),
                    initialDependency: initialDependency,
                    loadNext: loadNextSignal.asObservable()
                ) { dependency -> Observable<PageContext> in
                    pageProvider(dependency)
                        .asObservable()
                        .map { pageAgent -> PageContext in
                            Page(
                                nextDependency: pageAgent.nextDependency,
                                elements: pageAgent.elements
                            )
                        }
                }
                .catchError { _ in .empty() }
            }
            .map {
                PageState(
                    isLoading: $0.isLoading,
                    error: $0.error,
                    elements: $0.elements
                )
            }
    }
}

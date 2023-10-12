//
//  NotificationsViewModel.swift
//  fitapp
//

//

import Foundation
import RxSwift
import RxCocoa

enum NotificationType {
    case workout
    case comment
    case library
}

extension NotificationType {
    var title: String {
        switch self {
        case .workout:
            return "Workout"
        case .comment:
            return "Comment"
        case .library:
            return "Library"
        }
    }
    
    var imageName: String {
        switch self {
        case .workout:
            return "ChatCircleDots"
        case .comment:
            return "Barbell"
        case .library:
            return "Books"
        }
    }
}

class NotificationsViewModel: DeinitAnnouncerType {
    // MARK: - Private Properties
    
    fileprivate let coordinator: NotificationsCoordinator

    private let itemsRelay = BehaviorRelay<[NotificationCellViewModel]>(value: [])
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    init(_ coordinator: NotificationsCoordinator) {
        self.coordinator = coordinator
        
        itemsRelay.accept([
            .init(id: 0, type: .workout, title: "Today is training day “The Total Atack!"),
            .init(id: 1, type: .comment, title: "You have received a new reply to a comment"),
            .init(id: 2, type: .library, title: "Today is training day “The Total Atack!"),
            .init(id: 3, type: .comment, title: "You have a new recommended article for you"),
            .init(id: 4, type: .workout, title: "Today is training day “The Total Atack!"),
        ])
    }
    
    func route(to route: NotificationsCoordinator.Route) {
        coordinator.route(to: route)
    }
}

extension NotificationsViewModel: ViewModelProtocol {
    struct Input {
        let backSignal: Observable<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let items: Driver<[NotificationCellViewModel]>
        let isLoading: Driver<Bool>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupBackObserving(with: input.backSignal)
        ])
        
        let output = Output(
            items: itemsRelay.asDriver(onErrorJustReturn: []),
            isLoading: isLoadingRelay.asDriver(onErrorJustReturn: false)
        )
        
        outputHandler(output)
    }
    
    private func setupBackObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] _ in
            self?.coordinator.route(to: .back)
        }
    }
    
}

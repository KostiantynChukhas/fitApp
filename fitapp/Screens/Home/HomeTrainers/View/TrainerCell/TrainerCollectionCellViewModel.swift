//
//  TrainerCollectionCellViewModel.swift
//  fitapp
//
//  Created by  on 23.07.2023.
//

import Foundation
import RxSwift
import RxCocoa

class TrainerCollectionCellViewModel: Equatable, ReactiveCompatible {
    static func == (lhs: TrainerCollectionCellViewModel, rhs: TrainerCollectionCellViewModel) -> Bool {
        return lhs.trainer.id == rhs.trainer.id
    }
    
    let trainer: TrainerData
    
    let likeRelay: BehaviorRelay<Bool>
    let likeCountRelay: BehaviorRelay<Int>
    
    fileprivate var likeTapReplay = PublishSubject<TrainerCollectionCellViewModel>()
    
    init(trainer: TrainerData) {
        self.trainer = trainer
        self.likeRelay = .init(value: trainer.isMyLike)
        self.likeCountRelay = .init(value: trainer.modelTrainer.countLike)
    }

    func likeTapObservable() -> Observable<TrainerCollectionCellViewModel> {
        likeTapReplay.asObservable()
    }
    
}

extension Reactive where Base: TrainerCollectionCellViewModel {
    var likeTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.likeTapReplay.onNext(base.self)
        }
    }
}
    

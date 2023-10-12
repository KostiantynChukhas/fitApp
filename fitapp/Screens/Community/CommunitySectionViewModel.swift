//
//  CommunitySectionViewModel.swift
//  fitapp
//
//  on 18.05.2023.
//

import Foundation
import RxDataSources
import Differentiator
import RxCocoa
import RxSwift

enum CommunitySectionViewModel: SectionModelType {
    case feed(items: [CommunityType])
}

enum CommunityType {
    case feed(model: CommunityViewData)
}


class CommunityCellViewModel: Equatable, Hashable, ReactiveCompatible {
    var model: CommunityViewData
    
    var isLike: Bool
    var isDislike: Bool
    var likesCount: Int
    var dislikeCount: Int
    
    fileprivate var likeTapReplay = PublishSubject<CommunityCellViewModel>()
    fileprivate var dislikeTapReplay = PublishSubject<CommunityCellViewModel>()
    fileprivate var commentTapReplay = PublishSubject<CommunityCellViewModel>()
    fileprivate var shareTapRelay = PublishSubject<CommunityViewData>()

    
    var likeChangedRelay = PublishSubject<Bool>()
    var dislikeChangedRelay = PublishSubject<Bool>()

    init(model: CommunityViewData) {
        self.model = model
        self.isLike = model.isLike ?? false
        self.isDislike = model.isDislike ?? false
        self.likesCount = abs(model.countLike ?? .zero)
        self.dislikeCount = abs(model.countDislike ?? .zero)
    }

    func likeTapObservable() -> Observable<CommunityCellViewModel> {
        likeTapReplay.asObservable()
    }
    
    func dislikeTapObservable() -> Observable<CommunityCellViewModel> {
        dislikeTapReplay.asObservable()
    }
    
    func commentTapObservable() -> Observable<CommunityCellViewModel> {
        commentTapReplay.asObservable()
    }
    
    func shareTapObservable() -> Observable<CommunityViewData> {
        shareTapRelay.asObservable()
    }

    static func == (lhs: CommunityCellViewModel, rhs: CommunityCellViewModel) -> Bool {
        return lhs.model.id == rhs.model.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(model.id)
    }
}

extension CommunitySectionViewModel {
    typealias Item = CommunityType
    
    var items: [CommunityType] {
        switch self {
            
        case .feed(items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: CommunitySectionViewModel, items: [CommunityType]) {
        switch original {
        case .feed(items: _): self = .feed(items: items)

        }
    }
}

enum TypeCommunityPage: Int {
    case home
    case popular
    case news
    
    func getString() -> String? {
            switch self {
            case .home:
                return "home".uppercased()
            case .popular:
                return "popular".uppercased()
            case .news:
                return "news".uppercased()
            }
        }
}

extension Reactive where Base: CommunityCellViewModel {
    var likeTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.likeTapReplay.onNext(base.self)
        }
    }
    
    var dislikeTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.dislikeTapReplay.onNext(base.self)
        }
    }
    
    var commentTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.commentTapReplay.onNext((base.self))
        }
    }
    
    var shareTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.shareTapRelay.onNext((base.model))
        }
    }
}


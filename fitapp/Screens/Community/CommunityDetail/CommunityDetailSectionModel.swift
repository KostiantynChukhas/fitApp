//
//  CommunityDetailSectionModel.swift
//  fitapp
//
//  on 19.05.2023.
//

import Foundation
import RxDataSources
import RxCocoa
import RxSwift
import Differentiator

enum CommunityModelSectionType: Equatable, Hashable, IdentifiableType {
    
    var identity: Self {
        return self
    }
    
    case description(model: CommunityCellViewModel)
    case comments(model: CommunityArticleCommentsModel)
}


class CommunityArticleCommentsModel: Hashable, ReactiveCompatible {
    static func == (lhs: CommunityArticleCommentsModel, rhs: CommunityArticleCommentsModel) -> Bool {
        return lhs.model.id == rhs.model.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(model.id)
    }
    
    let model: CommunityCommentsData
    let isNested: Bool
    var isLike: Bool
    var isDislike: Bool
    var likesCount: Int
    var dislikeCount: Int
    
    fileprivate var replyTapReplay = PublishSubject<CommunityCommentsData>()
    fileprivate var moreTapReplay = PublishSubject<CommunityCommentsData>()
    fileprivate var likeTapReplay = PublishSubject<CommunityArticleCommentsModel>()
    fileprivate var dislikeTapReplay = PublishSubject<CommunityArticleCommentsModel>()
    
    var likeChangedRelay = PublishSubject<Bool>()
    var dislikeChangedRelay = PublishSubject<Bool>()
    
    init(commentsModel: CommunityCommentsData, isNested: Bool) {
        self.model = commentsModel
        self.isNested = isNested
        self.isLike = commentsModel.isLike ?? false
        self.isDislike = commentsModel.isDislike ?? false
        self.likesCount = commentsModel.countLike ?? .zero
        self.dislikeCount = commentsModel.countDislike ?? .zero
    }
    
    func replyTapObservable() -> Observable<CommunityCommentsData> {
        replyTapReplay.asObservable()
    }
    
    func moreTapObservable() -> Observable<CommunityCommentsData> {
        moreTapReplay.asObservable()
    }
    
    func likeTapObservable() -> Observable<CommunityArticleCommentsModel> {
        likeTapReplay.asObservable()
    }
    
    func dislikeTapObservable() -> Observable<CommunityArticleCommentsModel> {
        dislikeTapReplay.asObservable()
    }
}

extension Reactive where Base: CommunityArticleCommentsModel {
    var replyTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.replyTapReplay.onNext(base.model)
        }
    }
    
    var moreTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.moreTapReplay.onNext(base.model)
        }
    }
    
    var likeTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.likeTapReplay.onNext(base)
        }
    }
    
    var dislikeTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.dislikeTapReplay.onNext(base)
        }
    }
}



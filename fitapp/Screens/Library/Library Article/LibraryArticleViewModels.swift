//
//  LibraryArticleViewModels.swift
//  fitapp
//
//  on 14.05.2023.
//

import Foundation
import Differentiator
import RxDataSources
import RxCocoa
import RxSwift

enum LibraryModelSectionType: Equatable, Hashable, IdentifiableType {
    
    var identity: Self {
        return self
    }
    
    case description(model: LibraryArticleDescriptionCellViewModel)
    case comments(model: LibraryArticleCommentsModel)
    case titleComments
}

class LibraryArticleCommentsModel: Hashable, ReactiveCompatible {
    static func == (lhs: LibraryArticleCommentsModel, rhs: LibraryArticleCommentsModel) -> Bool {
        return lhs.commentsModel.id == rhs.commentsModel.id
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(commentsModel.id)
    }
    
    fileprivate var replyTapRelay = PublishSubject<LibraryCommentsData>()
    fileprivate var moreTapRelay = PublishSubject<LibraryCommentsData>()
    fileprivate var likeTapRelay = PublishSubject<LibraryArticleCommentsModel>()
    fileprivate var dislikeTapRelay = PublishSubject<LibraryArticleCommentsModel>()
    
    var likeChangedRelay = PublishSubject<Bool>()
    var dislikeChangedRelay = PublishSubject<Bool>()

    let commentsModel: LibraryCommentsData
    let isNested: Bool
    let nestedName: String?
    let nestedComment: String?
    var isLike: Bool
    var isDislike: Bool
    var likesCount: Int
    var dislikeCount: Int
    
    init(
        commentsModel: LibraryCommentsData,
        isNested: Bool,
        nestedName: String = "",
        nestedComment: String = ""
    ) {
        self.commentsModel = commentsModel
        self.isNested = isNested
        self.nestedName = nestedName
        self.nestedComment = nestedComment
        self.isLike = commentsModel.isLike ?? false
        self.isDislike = commentsModel.isDislike ?? false
        self.likesCount = abs(commentsModel.countLike ?? .zero)
        self.dislikeCount = abs(commentsModel.countDislike ?? .zero)
    }
    
    func replyTapObservable() -> Observable<LibraryCommentsData> {
        replyTapRelay.asObservable()
    }
    
    func likeTapObservable() -> Observable<LibraryArticleCommentsModel> {
        likeTapRelay.asObservable()
    }
    
    func dislikeTapObservable() -> Observable<LibraryArticleCommentsModel> {
        dislikeTapRelay.asObservable()
    }
    
    func moreTapObservable() -> Observable<LibraryCommentsData> {
        moreTapRelay.asObservable()
    }
}

class LibraryTitleCommentsModel: Hashable {
    static func == (lhs: LibraryTitleCommentsModel, rhs: LibraryTitleCommentsModel) -> Bool {
        return lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(title)
    }
    
    let title: String
    let filterTitle: String
    
    init(title: String, filterTitle: String) {
        self.title = title
        self.filterTitle = filterTitle
    }
}

class LibraryArticleDescriptionCellViewModel: Identifiable, Hashable {
    static func == (lhs: LibraryArticleDescriptionCellViewModel, rhs: LibraryArticleDescriptionCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
    }
    
    var id: String
    var text: String
    var nameAuthor: String
    var typeUser: String
    var time: String
    var imgUrl: String
    var imgAvatarUrl: String
    
    init(id: String, text: String, nameAuthor: String, typeUser: String, time: String, imgUrl: String, imgAvatarUrl: String) {
        self.text = text
        self.nameAuthor = nameAuthor
        self.typeUser = typeUser
        self.time = time
        self.imgUrl = imgUrl
        self.imgAvatarUrl = imgAvatarUrl
        self.id = id
    }
}

extension Reactive where Base: LibraryArticleCommentsModel {
    var replyTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.replyTapRelay.onNext(base.commentsModel)
        }
    }   
    
    var moreTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.moreTapRelay.onNext(base.commentsModel)
        }
    }
    
    var likeTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.likeTapRelay.onNext(base)
        }
    }
    
    var dislikeTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.dislikeTapRelay.onNext(base)
        }
    }
}





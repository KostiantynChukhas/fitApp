//
//  BookmarkService.swift
//  fitapp
//
//  Created by Тетяна Нєізвєстна on 20.09.2023.
//

import Foundation
import RxSwift
import RxCocoa

class BookmarkService {
    static let shared = BookmarkService()
    
    private let bookmarksUpdatedObserver = PublishSubject<Void>()
    
    var bookmarkUpdated: Observable<Void> {
        bookmarksUpdatedObserver.asObservable()
    }
    
    func updateBookmark() {
        bookmarksUpdatedObserver.onNext(())
    }
}


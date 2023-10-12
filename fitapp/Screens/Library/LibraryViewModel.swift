//
//  LibraryViewModel.swift
//  fitapp
//
//  on 07.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class Tags {
    let title: String
    let isSelected: Bool
    
    init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
}

class LibraryViewModel: DeinitAnnouncerType {
    // MARK: - Private Properties
    
    private var tagsRelay = BehaviorRelay<[TagCategoryModel]>(value: [])
        
    private let filterItemsRelay = BehaviorRelay<[LibraryList]>(value: [])
    
    private let libraryDataRelay = BehaviorRelay<[LibraryData]>(value: [])
    
    private var service = FitappNetworkService(baseURL: FitappURLs.getBaseURl(for: .release))
    
    private let searchTextRelay =  PublishSubject<String>()
    
    fileprivate let coordinator: LibraryCoordinator
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Observable
    
    init(_ coordinator: LibraryCoordinator) {
        self.coordinator = coordinator
    }
    
    func route(to route: LibraryCoordinator.Route) {
        coordinator.route(to: route)
    }
}

extension LibraryViewModel: ViewModelProtocol {
    struct Input {
        let disposeBag: DisposeBag
        let filteredButtonSignal: Observable<Void>
        let selectableTags: Observable<[TagCategoryModel]>
        let searchSignal: Observable<String>
        let emptySearchSignal: Observable<Bool>
        let modelSelected: Observable<LibraryList>
        let notificationsSignal: Observable<Void>
    }
    
    struct Output {
        let tagsObservable: Driver<[TagCategoryModel]>
        let itemsObservable: Driver<[LibraryList]>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupFilterTapButtonObserving(with: input.filteredButtonSignal),
            setupSectionsObservable(with: input.selectableTags),
            setupSearchBarInputObserving(with: input.searchSignal),
            setupSearchObserving(with: searchTextRelay.asObservable()),
            setupEmptySearchObserving(with: input.emptySearchSignal),
            setupModelSelectedObserving(with: input.modelSelected),
            setupLibrariesObserbing(),
            setupNotificationsClickObserving(with: input.notificationsSignal)
        ])
        
        let output = Output(
            tagsObservable: tagsRelay.asDriver(onErrorJustReturn: []),
            itemsObservable: filterItemsRelay.asDriver(onErrorJustReturn: [])
        )
        
        outputHandler(output)
     
    }
    
    private func setupEmptySearchObserving(with signal: Observable<Bool>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, searchIsEmpty) in
                if searchIsEmpty {
                    self.setupLibrariesObserbing()
                        .disposed(by: self.disposeBag)
                }
            })
    }
    
    private func setupSearchObserving(with signal: Observable<String>) -> Disposable {
        return signal
            .withUnretained(self)
            .flatMap { (`self`, text) in
                return self.service.getLibrary(requestData: LibraryRequestModel(limit: 50, categories: "", createdAtLast: "0", search: text)).asObservable()
            }
            .subscribe(onNext: { response in
                let libraryData: [LibraryData] = response.data
                self.libraryDataRelay.accept(libraryData)
                let libraryList: [LibraryList] = libraryData.compactMap { model in
                    return LibraryList(title: model.header, img: model.picture, id: model.id)
                }
                self.filterItemsRelay.accept(libraryList)
            })
    }
    
    private func setupSearchBarInputObserving(with signal: Observable<String>) -> Disposable {
        signal.bind(to: searchTextRelay)
    }
    
    private func setupSectionsObservable(with signal: Observable<[TagCategoryModel]>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, tags) in
                self.tagsRelay.accept(tags)
                let categories = tags.map({"\($0.id)"}).joined(separator: ",")
                self.setupLibrariesObserbing()
                    .disposed(by: self.disposeBag)
            })
    }
    
    private func setupFilterTapButtonObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] in
            self?.route(to: .categories)
        }
    }
    
    private func setupModelSelectedObserving(with signal: Observable<LibraryList>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (`self`, listModel) in
                guard let model = self.libraryDataRelay.value.filter({$0.id == listModel.id}).first else { return }
                self.route(to: .article(model: model))
            })
    }
    
    private func setupLibrariesObserbing() -> Disposable {
        let categories = tagsRelay.value.map({"\($0.id)"}).joined(separator: ",")
        return service
            .getLibrary(requestData: LibraryRequestModel(limit: 50, categories: categories, createdAtLast: "0", search: nil))
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (`self`, response) in
                let libraryData: [LibraryData] = response.data
                self.libraryDataRelay.accept(libraryData)
                let libraryList: [LibraryList] = libraryData.compactMap { model in
                    return LibraryList(title: model.header, img: model.picture, id: model.id)
                }
                self.filterItemsRelay.accept(libraryList)
            })
    }
    
    private func setupNotificationsClickObserving(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] _ in
            self?.coordinator.route(to: .notifications)
        }
    }
}

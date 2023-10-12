//
//  DiscoverCategoryViewModel.swift
//  fitapp
//
//  on 11.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class DiscoverCategoryViewModel: DeinitAnnouncerType {
    // MARK: - Private Properties
    
    private let itemListObservable = BehaviorRelay<[TagCategoryModel]>(value: [])

    fileprivate let coordinator: DiscoverCategoryCoordinator

    init(_ coordinator: DiscoverCategoryCoordinator) {
        self.coordinator = coordinator
        setupSectionsObservable()
    }
    
    func route(to route: DiscoverCategoryCoordinator.Route) {
        coordinator.route(to: route)
    }
}

extension DiscoverCategoryViewModel: ViewModelProtocol {
    struct Input {
        let disposeBag: DisposeBag
        let backSignal: Observable<Void>
        let applySignal: Observable<Void>
        let defaultSignal: Observable<Void>
        let modelSelected: Observable<TagCategoryModel>
    }
    
    struct Output {
        let tableItemsObservable: Driver<[TagCategoryModel]>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupBackButtonObservable(with: input.backSignal),
            setupModelSelectedObservable(with: input.modelSelected),
            setupApplayButtonObservable(with: input.applySignal),
            setupDefaultButtonObservable(with: input.defaultSignal)
        ])
        
        let output = Output(
            tableItemsObservable: itemListObservable.asDriver(onErrorJustReturn: [])
        )
        
        outputHandler(output)
        
    }
    
    private func setupBackButtonObservable(with signal: Observable<Void>) -> Disposable {
        signal.bind { [weak self] _ in
            self?.route(to: .back)
        }
    }
    
    private func setupSectionsObservable() {
        let category = TagCategoryModel(title: "All categories", image: "Training_card", isSelected: false, id: 0)
        let category1 = TagCategoryModel(title: "Diet", image: "Training_card-1", isSelected: false, id: 1)
        let category2 = TagCategoryModel(title: "Cardio", image: "Training_card-2", isSelected: false, id: 2)
        let category3 = TagCategoryModel(title: "Fitness", image: "Training_card-3", isSelected: false, id: 3)
        let category4 = TagCategoryModel(title: "Strength", image: "Training_card-4", isSelected: false, id: 4)
        let category5 = TagCategoryModel(title: "Arms", image: "Training_card-5", isSelected: false, id: 5)
        let category6 = TagCategoryModel(title: "Health", image: "Training_card-6", isSelected: false, id: 6)
        let category7 = TagCategoryModel(title: "Back", image: "Training_card-7", isSelected: false, id: 7)

        let categories = [category, category1, category2, category3, category4, category5, category6, category7 ]
        let selectedCategories = DiscoverCategoryService.shared.getCategories()
        
        for index in 0..<categories.count {
            categories[index].isSelected = selectedCategories.contains(where: { $0.id == categories[index].id })
        }
        
        itemListObservable.accept(categories)
    }
    
    private func setupModelSelectedObservable(with signal: Observable<TagCategoryModel>) -> Disposable {
        signal.bind { [weak self] model in
            let items = self?.itemListObservable.value ?? []
            
            let index = items.firstIndex(where: { $0 == model })
            
            if index == .zero {
                let isSelected = model.isSelected
                items.forEach {$0.select(!isSelected) }
            } else {
                model.toggle()
                items.first?.select(false)
            }
            
            let selectedCategories = items.filter({ $0.isSelected })
            DiscoverCategoryService.shared.addCategory(categories: selectedCategories)
        }
    }
    
    private func setupDefaultButtonObservable(with signal: Observable<Void>) -> Disposable  {
        signal.bind { [weak self] in
            let items = self?.itemListObservable.value ?? []
            items.forEach { $0.select(true) }
            DiscoverCategoryService.shared.addCategory(categories: items)
        }
    }
    
    private func setupApplayButtonObservable(with signal: Observable<Void>) -> Disposable  {
        signal.bind { [weak self] in
            self?.route(to: .back)
        }
    }
}

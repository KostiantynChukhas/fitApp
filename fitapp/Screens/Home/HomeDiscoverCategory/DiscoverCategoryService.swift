//
//  DiscoverCategoryService.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 05.07.2023.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa

class DiscoverCategoryService {
    static let shared = DiscoverCategoryService()
    
    private let selectedCategoryRelay = BehaviorRelay<[TagCategoryModel]>(value: [])
    private let tagsRelay = BehaviorRelay<[Tags]>(value: [])
    
    private init() {
        if let data = UserDefaults.standard.data(forKey: "selectedDiscoverCategories") {
            do {
                let decoder = JSONDecoder()
                let array = try decoder.decode([TagCategoryModel].self, from: data)
                
                // Use the retrieved array
                self.selectedCategoryRelay.accept(array)
            } catch {
                print("Error decoding array: \(error.localizedDescription)")
            }
        }
    }
    
    var selectedCategory: Observable<[TagCategoryModel]> {
        return selectedCategoryRelay.asObservable()
    }
    
    var tags: Observable<[Tags]> {
        return tagsRelay.asObservable()
    }
    
    func getCategories() -> [TagCategoryModel] {
        if let data = UserDefaults.standard.data(forKey: "selectedDiscoverCategories") {
            do {
                let decoder = JSONDecoder()
                let array = try decoder.decode([TagCategoryModel].self, from: data)
                
                // Use the retrieved array
                return array
            } catch {
                print("Error decoding array: \(error.localizedDescription)")
            }
        }
        
        return []
    }
    
    func addCategory(categories: [TagCategoryModel]) {
        selectedCategoryRelay.accept(categories)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(categories)
            
            // Save the encoded data into UserDefaults
            UserDefaults.standard.set(data, forKey: "selectedDiscoverCategories")
        } catch {
            print("Error encoding array: \(error.localizedDescription)")
        }
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: "selectedDiscoverCategories")
    }
}


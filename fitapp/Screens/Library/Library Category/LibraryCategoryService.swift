//
//  LibraryCategoryService.swift
//  fitapp
//
//  on 11.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

class LibraryCategoryService {
    static let shared = LibraryCategoryService()
    
    private let selectedCategoryRelay = BehaviorRelay<[TagCategoryModel]>(value: [])
    private let tagsRelay = BehaviorRelay<[Tags]>(value: [])
    
    private init() {
        if let data = UserDefaults.standard.data(forKey: "selectedCategories") {
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
        selectedCategoryRelay.asObservable()
    }
    
    var tags: Observable<[Tags]> {
        tagsRelay.asObservable()
    }
    
    func getCategories() -> [TagCategoryModel] {
        if let data = UserDefaults.standard.data(forKey: "selectedCategories") {
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
            UserDefaults.standard.set(data, forKey: "selectedCategories")
        } catch {
            print("Error encoding array: \(error.localizedDescription)")
        }
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: "selectedCategories")
    }
}


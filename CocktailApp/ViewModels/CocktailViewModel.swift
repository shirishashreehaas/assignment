//
//  CocktailViewModel.swift
//  CocktailApp
//
//  Created by Venkat_test on 26/12/2024.
//

import Combine
import Foundation

class CocktailViewModel: ObservableObject {
   // @Published var categories: [CocktailCategory] = []
    @Published var cocktails: [CocktailItem] = []
    @Published var cocktailDetails: CocktailDetails?
    @Published var errorMessage: String?
    @Published var favoriteCocktailIDs: Set<String> = []
    var favoritesKey = "favoriteCocktailIDs" // Key for UserDefaults

    private let apiService: CocktailAPIServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(service: CocktailAPIServiceProtocol) {
        self.apiService = service;
    }
    
//    func loadCategories() {
//        apiService.fetchCategories()
//            .sink(receiveCompletion: { completion in
//                if case .failure(let error) = completion {
//                    self.errorMessage = error.localizedDescription
//                }
//            }, receiveValue: { [weak self] categories in
//                self?.categories = categories
//            })
//            .store(in: &cancellables)
//    }
    
    func loadCocktails(filter: String) {
        apiService.fetchCocktails(filter: filter)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] fetchedCocktails in
                guard let self = self else { return }
                self.cocktails = fetchedCocktails.map { cocktail in
                    var mutableCocktail = cocktail
                    mutableCocktail.isFavorite = self.favoriteCocktailIDs.contains(cocktail.id)
                    return mutableCocktail
                }.sorted { $0.strDrink < $1.strDrink }
            })
            .store(in: &cancellables)
    }
    
    func loadCocktailDetails(id: String) {
        apiService.fetchCocktailDetails(id: id)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] details in
                self?.cocktailDetails = details
            })
            .store(in: &cancellables)
    }
    
    func toggleFavorite(for cocktailItem: CocktailItem) {
        if favoriteCocktailIDs.contains(cocktailItem.id) {
            favoriteCocktailIDs.remove(cocktailItem.id)
        } else {
            favoriteCocktailIDs.insert(cocktailItem.id)
        }
        saveFavorites()
        updateFavoriteStatus()
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteCocktailIDs), forKey: favoritesKey)
    }
    
    func loadFavorites() {
        let savedIDs = UserDefaults.standard.array(forKey: favoritesKey) as? [String] ?? []
        favoriteCocktailIDs = Set(savedIDs)
        print("Loaded Favorites: \(favoriteCocktailIDs)")

    }
    
    private func updateFavoriteStatus() {
        cocktails = cocktails.map { cocktail in
            var mutableCocktail = cocktail
            mutableCocktail.isFavorite = favoriteCocktailIDs.contains(cocktail.id)
            return mutableCocktail
        }
    }
    
//    func filteredCocktails() -> [CocktailItem] {
//        let filtered = filterState == .all ? cocktails :
//            cocktails.filter { $0.isAlcoholic == (filterState == .alcoholic) }
//
//        // Favorite cocktails pinned at the top
//        var vv = filtered.sorted {
//            if $0.isFavorite != $1.isFavorite {
//                return $0.isFavorite
//            }
//            return $0.name < $1.name
//        }
//        return vv
//    }
}

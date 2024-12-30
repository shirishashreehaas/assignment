//
//  CocktailViewModel.swift
//  CocktailApp
//
//  Created by Venkat_test on 26/12/2024.
//

import Combine
import Foundation

class CocktailViewModel: ObservableObject {
    @Published var cocktails: [CocktailItem] = []
    @Published var cocktailDetails: CocktailDetails?
    @Published var errorMessage: String?
    @Published var favoriteCocktailIDs: Set<String> = []
    @Published var isLoading: Bool = false

    var favoritesKey = "favoriteCocktailIDs" // Key for UserDefaults

    private let apiService: CocktailAPIServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(service: CocktailAPIServiceProtocol) {
        self.apiService = service;
        loadFavorites()

    }

    
    func loadCocktails(filter: String) {
        isLoading = true
              errorMessage = nil

        apiService.fetchCocktails(filter: filter)
            .sink(receiveCompletion: { completion in
                self.isLoading = false

                switch completion {
                            case .failure(let error):
                    self.cocktails = []
                                if let apiError = error as? APIError {
                                    self.errorMessage = apiError.errorDescription // Use APIError's description
                                } else {
                                    self.errorMessage = "An unexpected error occurred. Please try again."
                                }
                            case .finished:
                                break
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
    
//    func loadCocktailDetails(id: String) {
//        isLoading = true
//              errorMessage = nil
//       // self.cocktailDetails = nil
//
//        apiService.fetchCocktailDetails(id: id)
//            .sink(receiveCompletion: { completion in
//                self.isLoading = false
//
//                switch completion {
//                            case .failure(let error):
//                                if let apiError = error as? APIError {
//                                    self.errorMessage = apiError.errorDescription // Use APIError's description
//                                } else {
//                                    self.errorMessage = "An unexpected error occurred. Please try again."
//                                }
//                            case .finished:
//                                break
//                            }
//            }, receiveValue: { [weak self] details in
//                self?.cocktailDetails = details
//            })
//            .store(in: &cancellables)
//    }
    
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
    func isFavorite(cocktailID: String) -> Bool {
            guard let index = cocktails.firstIndex(where: { $0.idDrink == cocktailID }) else {
                return false
            }
            return cocktails[index].isFavorite
        }
    
    private func updateFavoriteStatus() {
        cocktails = cocktails.map { cocktail in
            var mutableCocktail = cocktail
            mutableCocktail.isFavorite = favoriteCocktailIDs.contains(cocktail.id)
            return mutableCocktail
        }
    }
    

}

//
//  CocktailViewModel.swift
//  CocktailApp
//
//  Created by Venkat_test on 26/12/2024.
//

import Combine
import Foundation

class CocktailViewModel: ObservableObject {
    // Published properties to bind UI with state

    @Published var cocktails: [CocktailItem] = [] // List of cocktails
    @Published var errorMessage: String? // Displays error messages/
    @Published var favoriteCocktailIDs: Set<String> = [] // List of favorite cocktails
    @Published var isLoading: Bool = false // Tracks loading state

    var favoritesKey = "favoriteCocktailIDs" // Key for UserDefaults

    private let apiService: CocktailAPIServiceProtocol //The service responsible for fetching cocktail data
    private var cancellables: Set<AnyCancellable> = []
    
    /// Initializes the ViewModel with an API service
    /// - Parameter service: The service responsible for fetching cocktail data
    init(service: CocktailAPIServiceProtocol) {
        self.apiService = service;
        loadFavorites()

    }

    /// Fetches cocktails from the API
    /// - Parameter filter: The type of cocktail to filter (e.g., Alcoholic)
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
    
    ///  toggles isFavorite of cocktail
    /// - Parameter cocktailItem: cocktail to taggle
    func toggleFavorite(for cocktailItem: CocktailItem) {
        if favoriteCocktailIDs.contains(cocktailItem.id) {
            favoriteCocktailIDs.remove(cocktailItem.id)
        } else {
            favoriteCocktailIDs.insert(cocktailItem.id)
        }
        saveFavorites()
        updateFavoriteStatus()
    }
    
    ///  save list of favorite cocktails ids
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteCocktailIDs), forKey: favoritesKey)
    }
    
    ///   Load list of favorite cocktails ids to favoriteCocktailIDs
    func loadFavorites() {
        let savedIDs = UserDefaults.standard.array(forKey: favoritesKey) as? [String] ?? []
        favoriteCocktailIDs = Set(savedIDs)
        print("Loaded Favorites: \(favoriteCocktailIDs)")

    }
    
    
    ///  check if cocktail is made as favorite or not
    /// - Parameter cocktailID: The id of cocktail to check
    func isFavorite(cocktailID: String) -> Bool {
            guard let index = cocktails.firstIndex(where: { $0.idDrink == cocktailID }) else {
                return false
            }
            return cocktails[index].isFavorite
        }
    
    ///  update list of  cocktails  isFavorite property
    private func updateFavoriteStatus() {
        cocktails = cocktails.map { cocktail in
            var mutableCocktail = cocktail
            mutableCocktail.isFavorite = favoriteCocktailIDs.contains(cocktail.id)
            return mutableCocktail
        }
    }
    

}

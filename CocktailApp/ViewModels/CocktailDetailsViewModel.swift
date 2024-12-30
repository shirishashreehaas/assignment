//
//  CocktailDetailsViewModel.swift
//  CocktailApp
//
//  Created by Venkat_test on 30/12/2024.
//

import Foundation
import Combine
class CocktailDetailsViewModel: ObservableObject {
    @Published var cocktailDetails: CocktailDetails?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let apiService: CocktailAPIServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(apiService: CocktailAPIServiceProtocol) {
        self.apiService = apiService
    }

    func loadCocktailDetails(id: String) {
        isLoading = true
              errorMessage = nil
       // self.cocktailDetails = nil

        apiService.fetchCocktailDetails(id: id)
            .sink(receiveCompletion: { completion in
                self.isLoading = false

                switch completion {
                            case .failure(let error):
                                if let apiError = error as? APIError {
                                    self.errorMessage = apiError.errorDescription // Use APIError's description
                                    self.cocktailDetails = nil
                                } else {
                                    self.errorMessage = "An unexpected error occurred. Please try again."
                                    self.cocktailDetails = nil
                                }
                            case .finished:
                                break
                            }
            }, receiveValue: { [weak self] details in
                self?.cocktailDetails = details
            })
            .store(in: &cancellables)
    }
}

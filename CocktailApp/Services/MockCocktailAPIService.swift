//
//  MockCocktailAPIService.swift
//  CocktailApp
//
//  Created by Venkat_test on 27/12/2024.
//

import Combine
import Foundation

class MockCocktailAPIService: CocktailAPIServiceProtocol {
    var mockCocktails: [CocktailItem] = []
      var mockCocktailDetails: CocktailDetails?
      var shouldFail = false
    var errorToThrow: APIError = .unknownError

    func fetchCocktailDetails(id: String) -> AnyPublisher<CocktailDetails, Error> {
        if shouldFail || mockCocktailDetails == nil {
               return Fail(error: errorToThrow)
                               .eraseToAnyPublisher()
           } else if let details = mockCocktailDetails {
               return Just(details)
                   .setFailureType(to: Error.self)
                   .eraseToAnyPublisher()
           } else {
               return Fail(error: URLError(.dataNotAllowed))
                   .eraseToAnyPublisher()
           }
       }
    


    func fetchCocktails(filter: String) -> AnyPublisher<[CocktailItem], Error> {
        let mockCocktails = [
                   CocktailItem(idDrink: "1", strDrink: "Mock Margarita", strDrinkThumb: "", isFavorite: false),
                   CocktailItem(idDrink: "2", strDrink: "Mock Mojito", strDrinkThumb: "", isFavorite: false)
               ]
        if shouldFail {
            return Fail(error: errorToThrow)
                            .eraseToAnyPublisher()
        } else {
            return Just(mockCocktails)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    
}


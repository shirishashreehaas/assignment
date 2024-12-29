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
    
    func fetchCocktailDetails(id: String) -> AnyPublisher<CocktailDetails, Error> {
           if shouldFail {
               return Fail(error: URLError(.badServerResponse))
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
        if shouldFail {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        } else {
            return Just(mockCocktails)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    
}


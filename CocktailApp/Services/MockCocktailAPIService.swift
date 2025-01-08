//
//  MockCocktailAPIService.swift
//  CocktailApp
//
//  Created by Venkat_test on 27/12/2024.
//

import Combine
import Foundation


/// A mock implementation of the `CocktailAPIServiceProtocol` for testing purposes.
///
/// This mock service simulates network requests and responses for fetching cocktails and cocktail details.
/// It allows controlling the behavior of the service, such as simulating successful responses, failures, or specific data.

class MockCocktailAPIService: CocktailAPIServiceProtocol {
    
    /// Mock data for cocktails, used to simulate API responses.
    var mockCocktails: [CocktailItem] = []

    /// Mock data for cocktail details, used to simulate API responses for a single cocktail.
    var mockCocktailDetails: CocktailDetails?

    /// Flag to indicate whether the service should simulate a failure.
    var shouldFail = false

    /// The error to throw when simulating a failure.
    var errorToThrow: APIError = .unknownError

    /// Simulates fetching details for a specific cocktail by its ID.
    ///
    /// - Parameter id: The unique ID of the cocktail.
    /// - Returns: A publisher emitting either a `CocktailDetails` object or an error.
    func fetchCocktailDetails(id: String) -> AnyPublisher<CocktailDetails, Error> {
        if shouldFail || mockCocktailDetails == nil {
            // Simulate a failure by returning the specified error
            return Fail(error: errorToThrow)
                .eraseToAnyPublisher()
        } else if let details = mockCocktailDetails {
            // Simulate a successful response with the mock cocktail details
            return Just(details)
                .setFailureType(to: Error.self) // Match the expected publisher error type
                .eraseToAnyPublisher()
        } else {
            // Simulate an unexpected error, such as no data allowed
            return Fail(error: URLError(.dataNotAllowed))
                .eraseToAnyPublisher()
        }
    }

    /// Simulates fetching a list of cocktails filtered by type.
    ///
    /// - Parameter filter: The type of cocktails to fetch (e.g., "Alcoholic" or "Non-Alcoholic").
    /// - Returns: A publisher emitting an array of `CocktailItem` or an error.
    func fetchCocktails(filter: String) -> AnyPublisher<[CocktailItem], Error> {
        // Example mock cocktails data
        let mockCocktails = [
            CocktailItem(idDrink: "1", strDrink: "Mock Margarita", strDrinkThumb: "", isFavorite: false),
            CocktailItem(idDrink: "2", strDrink: "Mock Mojito", strDrinkThumb: "", isFavorite: false)
        ]
        
        if shouldFail {
            // Simulate a failure by returning the specified error
            return Fail(error: errorToThrow)
                .eraseToAnyPublisher()
        } else {
            // Simulate a successful response with the mock cocktails list
            return Just(mockCocktails)
                .setFailureType(to: Error.self) // Match the expected publisher error type
                .eraseToAnyPublisher()
        }
    }
}

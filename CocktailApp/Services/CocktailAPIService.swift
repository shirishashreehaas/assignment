//
//  CocktailAPIService.swift
//  CocktailApp
//
//  Created by Venkat_test on 26/12/2024.
//

import Foundation
import Combine

import Foundation
import Combine

/// A service that interacts with the CocktailDB API to fetch cocktail-related data.
///
/// - Implements the `CocktailAPIServiceProtocol` to ensure consistent API service behavior.
/// - Provides methods to fetch a list of cocktails and detailed information for a specific cocktail.
class CocktailAPIService: CocktailAPIServiceProtocol {
    
    /// The base URL for the CocktailDB API.
    private let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/"

    /// Fetches a list of cocktails filtered by type (e.g., "Alcoholic" or "Non-Alcoholic").
    ///
    /// - Parameter filter: The type of cocktails to fetch, such as "Alcoholic" or "Non_Alcoholic".
    /// - Returns: A publisher emitting an array of `CocktailItem` or an error.
    func fetchCocktails(filter: String) -> AnyPublisher<[CocktailItem], Error> {
        // Construct the URL for the API request
        let url = URL(string: "\(baseURL)filter.php?a=\(filter)")!
        
        return URLSession.shared.dataTaskPublisher(for: url) // Make a network request
            .map(\.data) // Extract the data from the response
            .decode(type: [String: [CocktailItem]].self, decoder: JSONDecoder()) // Decode the JSON into a dictionary
            .map { $0["drinks"] ?? [] } // Extract the "drinks" array or return an empty array if not found
            .receive(on: DispatchQueue.main) // Ensure the result is delivered on the main thread
            .mapError { error in
                // Map errors to custom APIError types for better error handling
                if let urlError = error as? URLError {
                    return APIError.networkError
                } else if let decodingError = error as? DecodingError {
                    return APIError.decodingError
                }
                return APIError.unknownError
            }
            .eraseToAnyPublisher() // Convert to a type-erased publisher
    }

    /// Fetches detailed information for a specific cocktail by its ID.
    ///
    /// - Parameter id: The unique ID of the cocktail.
    /// - Returns: A publisher emitting a `CocktailDetails` object or an error.
    func fetchCocktailDetails(id: String) -> AnyPublisher<CocktailDetails, Error> {
        // Construct the URL for the API request
        let url = URL(string: "\(baseURL)lookup.php?i=\(id)")!
        
        return URLSession.shared.dataTaskPublisher(for: url) // Make a network request
            .map(\.data) // Extract the data from the response
            .decode(type: [String: [CocktailDetails]].self, decoder: JSONDecoder()) // Decode the JSON into a dictionary
            .compactMap { $0["drinks"]?.first } // Extract the first item from the "drinks" array, if available
            .receive(on: DispatchQueue.main) // Ensure the result is delivered on the main thread
            .mapError { error in
                // Map errors to custom APIError types for better error handling
                if let urlError = error as? URLError {
                    return APIError.networkError
                } else if let decodingError = error as? DecodingError {
                    return APIError.decodingError
                }
                return APIError.unknownError
            }
            .eraseToAnyPublisher() // Convert to a type-erased publisher
    }
}


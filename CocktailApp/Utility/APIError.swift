//
//  APIError.swift
//  CocktailApp
//
//  Created by Venkat_test on 30/12/2024.
//

import Foundation
/// Represents various types of errors that can occur during API calls.
///
/// The `APIError` enum conforms to the `LocalizedError` protocol, providing user-friendly error descriptions.
/// Each case corresponds to a specific error scenario that the app might encounter when communicating with the server.
enum APIError: LocalizedError {
    case networkError
    case decodingError
    case unknownError
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network connection failed. Please check your internet connection."
        case .decodingError:
            return "Failed to process the server response. Please try again later."
        case .unknownError:
            return "An unknown error occurred. Please try again."
        case .invalidResponse:
                   return "Invalid response from server."
        }
    }
}

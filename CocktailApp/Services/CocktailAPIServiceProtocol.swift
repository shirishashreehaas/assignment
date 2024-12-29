//
//  CocktailAPIServiceProtocol.swift
//  CocktailApp
//
//  Created by Venkat_test on 27/12/2024.
//

import Foundation
import Combine
protocol CocktailAPIServiceProtocol {
    func fetchCocktails(filter: String) -> AnyPublisher<[CocktailItem], Error> 
    func fetchCocktailDetails(id: String) -> AnyPublisher<CocktailDetails, Error>
}


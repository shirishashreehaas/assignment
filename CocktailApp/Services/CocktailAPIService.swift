//
//  CocktailAPIService.swift
//  CocktailApp
//
//  Created by Venkat_test on 26/12/2024.
//

import Foundation
import Combine

class CocktailAPIService :  CocktailAPIServiceProtocol {
   
    
    private let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/"
    
//    func fetchCategories() -> AnyPublisher<[CocktailCategory], Error> {
//        let url = URL(string: "\(baseURL)list.php?c=list")!
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map(\.data)
//            .decode(type: [String: [CocktailCategory]].self, decoder: JSONDecoder())
//            .map { $0["drinks"] ?? [] }
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
//
    func fetchCocktails(filter: String) -> AnyPublisher<[CocktailItem], Error> {
        let url = URL(string: "\(baseURL)filter.php?a=\(filter)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [String: [CocktailItem]].self, decoder: JSONDecoder())
            .map { $0["drinks"] ?? [] }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchCocktailDetails(id: String) -> AnyPublisher<CocktailDetails, Error> {
        let url = URL(string: "\(baseURL)lookup.php?i=\(id)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [String: [CocktailDetails]].self, decoder: JSONDecoder())
            .compactMap { $0["drinks"]?.first }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

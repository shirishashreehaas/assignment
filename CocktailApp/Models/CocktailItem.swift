//
//  CocktailItem.swift
//  CocktailApp
//
//  Created by Venkat_test on 26/12/2024.
//

struct CocktailItem: Identifiable, Codable {
    let idDrink: String
    let strDrink: String
    let strDrinkThumb: String
    
    var id: String { idDrink }
    
    // Default value ensures no decoding errors
    var isFavorite: Bool = false

    // CodingKeys to map JSON keys explicitly
    enum CodingKeys: String, CodingKey {
        case idDrink
        case strDrink
        case strDrinkThumb
    }
}


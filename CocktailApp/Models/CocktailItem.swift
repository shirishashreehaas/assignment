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
    
    var isFavorite: Bool = false

    enum CodingKeys: String, CodingKey {
        case idDrink
        case strDrink
        case strDrinkThumb
    }
}


//
//  CocktailDetailView.swift
//  CocktailApp
//
//  Created by Venkat_test on 26/12/2024.
//

import SwiftUI

struct CocktailDetailView: View {
   // @StateObject private var viewModel = CocktailViewModel()
    @ObservedObject var viewModel: CocktailViewModel

    let cocktail: CocktailItem
  //  let isFavorite: Bool

    var body: some View {
        VStack(alignment: .leading,spacing: 20) {
            if let details = viewModel.cocktailDetails {
                Text(details.strDrink)
                    .font(.largeTitle)
                    .bold()
              
                AsyncImage(url: URL(string: details.strDrinkThumb)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } placeholder: {
                    ProgressView()
                }
                .clipShape(Circle())
                
                
                Text("Description")
                    .font(.headline)
                
                Text(details.strInstructions)
                
                Text("Ingredients")
                    .font(.headline)
                
                VStack(alignment: .leading){
                    if let ingredient1 = details.strIngredient1 {
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.blue)
                            Text(ingredient1)
                            
                        }
                        
                    }
                    if let ingredient2 = details.strIngredient2 {
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.blue)
                            Text(ingredient2)
                            
                        }
                    }
                    if let ingredient3 = details.strIngredient3 { HStack {
                        Image(systemName: "drop.fill")
                            .foregroundColor(.blue)
                        Text(ingredient3)
                        
                    } }
                    
                        
                }
                
                
                
                  
                    .navigationBarTitle(Text(details.strDrink), displayMode: .inline)
                    .navigationBarItems(
                                trailing: Button(action: {
                                    viewModel.toggleFavorite(for: cocktail)
                                }) {
                                    Image(systemName: cocktail.isFavorite ? "heart.fill" : "heart")
                                        .foregroundColor(cocktail.isFavorite ? .red : .gray)
                                       

                                }
                            )
            }
            else {
                ProgressView()
            }
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.loadCocktailDetails(id: cocktail.id)
        }
    }
}

//
//  CocktailDetailView.swift
//  CocktailApp
//
//  Created by Venkat_test on 26/12/2024.
//

import SwiftUI
//
//struct CocktailDetailView: View {
//    @ObservedObject var viewModel: CocktailViewModel
//    @ObservedObject var viewModel1: CocktailDetailsViewModel
//
//    let cocktail: CocktailItem
//    @State private var localDetails: CocktailDetails? // Cache details locally
//
//    var body: some View {
//        VStack(alignment: .leading,spacing: 20) {
//            if viewModel1.isLoading {
//                ProgressView("Loading CocktailDetails...")
//                    .padding()
//                    .foregroundColor(.gray)
//
//            } else if let errorMessage = viewModel1.errorMessage {
//                VStack(spacing: 20) {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .multilineTextAlignment(.center)
//
//                    Button(action: {
//                        viewModel1.loadCocktailDetails(id: cocktail.id)
//                    }) {
//                        Text("Retry")
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                }
//                .padding()
//            } else {
//                    VStack(alignment: .leading, spacing: 20){
//                        if let details = localDetails ?? viewModel.cocktailDetails {
//                        Text(details.strDrink)
//                            .font(.largeTitle)
//                            .bold()
//
//
//                        AsyncImageView(imageURL: cocktail.strDrinkThumb)
//                            .frame(height: 300)
//                            .clipped()
//                            .cornerRadius(12)
//                            .padding(.bottom, 16)
//
//                        Text("Description")
//                            .font(.headline)
//
//                        Text(details.strInstructions)
//
//                        Text("Ingredients")
//                            .font(.headline)
//
//                        VStack(alignment: .leading){
//                            if let ingredient1 = details.strIngredient1 {
//                                HStack {
//                                    Image(systemName: "drop.fill")
//                                        .foregroundColor(.blue)
//                                    Text(ingredient1)
//
//                                }
//
//                            }
//                            if let ingredient2 = details.strIngredient2 {
//                                HStack {
//                                    Image(systemName: "drop.fill")
//                                        .foregroundColor(.blue)
//                                    Text(ingredient2)
//
//                                }
//                            }
//                            if let ingredient3 = details.strIngredient3 { HStack {
//                                Image(systemName: "drop.fill")
//                                    .foregroundColor(.blue)
//                                Text(ingredient3)
//
//                            } }
//
//
//                        }
//
//
//
//                        .navigationTitle(localDetails?.strDrink ?? viewModel.cocktailDetails?.strDrink ?? "Details")
//                       // .navigationBarTitle(Text(details.strDrink), displayMode: .inline)
//                        //.disabled(viewModel.isLoading)
//
//                        .navigationBarItems(
//                            trailing: Button(action: {
//                                viewModel.toggleFavorite(for: cocktail)
//                            }) {
//                                Image(systemName: cocktail.isFavorite ? "heart.fill" : "heart")
//                                    .foregroundColor(cocktail.isFavorite ? .red : .gray)
//
//
//                            }
//                        )
//                        .onAppear {
//                            // Cache the details locally on view load
//                            self.localDetails = details
//                        }
//                    }
//                    else {
//                        VStack {
//                            Spacer()
//                            Text("No details available.")
//                                .foregroundColor(.gray)
//                                .multilineTextAlignment(.center)
//                            Spacer()
//                        }
//                    }
//                    Spacer()
//
//                }
//
//
//            }
//        }
//        .padding()
//        .onAppear {
//            if viewModel1.cocktailDetails == nil {
//
//                viewModel1.loadCocktailDetails(id: cocktail.id)
//            }
//        }
////        .onDisappear()
////        {
////            viewModel1.cocktailDetails = nil
////        }
//    }
//}
struct CocktailDetailView: View {
    @ObservedObject var cocktailListViewModel: CocktailViewModel
    @ObservedObject var cocktailDetailViewModel: CocktailDetailsViewModel
    let cocktail: CocktailItem

    @State private var localDetails: CocktailDetails? // Cache details locally

    var body: some View {
        ZStack {
            if cocktailDetailViewModel.isLoading {
                ProgressView("Loading details...")
                    .padding()
            } else if let details = localDetails ?? cocktailDetailViewModel.cocktailDetails {
                ScrollView {
                    VStack(alignment: .leading,spacing: 20) {
                        
                        Text(details.strDrink)
                            .font(.largeTitle)
                            .bold()
                        
                        
                        AsyncImageView(imageURL: cocktail.strDrinkThumb)
                            .frame(height: 300)
                            .clipped()
                            .cornerRadius(12)
                            .padding(.bottom, 16)
                        
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
                    }
                }
                .onAppear {
                    // Cache the details locally on view load
                    self.localDetails = details
                }
            } else if let errorMessage = cocktailDetailViewModel.errorMessage {
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                    
                    Button(action: {
                        cocktailDetailViewModel.loadCocktailDetails(id: cocktail.id)
                    }) {
                        Text("Retry")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            } else {
                Text("No details available.")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            // Fetch details only if not already loaded
            if cocktailDetailViewModel.cocktailDetails == nil {
                cocktailDetailViewModel.loadCocktailDetails(id: cocktail.id)
            }
        }
        .navigationTitle(localDetails?.strDrink ?? cocktailDetailViewModel.cocktailDetails?.strDrink ?? "Details")
        .disabled(cocktailDetailViewModel.isLoading)
        .toolbar{
            if let details = localDetails ?? cocktailDetailViewModel.cocktailDetails {

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    cocktailListViewModel.toggleFavorite(for: cocktail)
                }) {
                    Image(systemName: cocktail.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(cocktail.isFavorite ? .red : .gray)
                }
            }
        }
    }
        
//        .navigationBarItems(
//                                   trailing: Button(action: {
//                                       cocktailListViewModel.toggleFavorite(for: cocktail)
//                                   }) {
//                                       Image(systemName: cocktail.isFavorite ? "heart.fill" : "heart")
//                                           .foregroundColor(cocktail.isFavorite ? .red : .gray)
//
//
//                                   }
//                               )
        .navigationBarTitleDisplayMode(.inline)
    }
}


//
//  CocktailListView.swift
//  CocktailApp
//
//  Created by Venkat_test on 26/12/2024.
//

import SwiftUI

struct CocktailListView: View {
    @StateObject private var viewModel: CocktailViewModel
    @State private var selectedFilter = "Alcoholic"
    init(viewModel: CocktailViewModel) {
           _viewModel = StateObject(wrappedValue: viewModel)
       }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $selectedFilter) {
                    Text("Alcoholic").tag("Alcoholic")
                    Text("Non-Alcoholic").tag("Non_Alcoholic")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List(viewModel.cocktails) { cocktail in
                    NavigationLink(destination: CocktailDetailView(viewModel: viewModel, cocktail: cocktail)) {
                        HStack {
//                            AsyncImage(url: URL(string: cocktail.strDrinkThumb)) { image in
//                                image.resizable()
//                            } placeholder: {
//                                ProgressView()
//                            }
//                            .frame(width: 50, height: 50)
//                            .clipShape(Circle())
                            
                            AsyncImageView(imageURL: cocktail.strDrinkThumb)
                                            .frame(width: 80, height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .padding(.trailing, 8)
                            
                            Text(cocktail.strDrink)
                            
                            Spacer()
                            Button(action: {
                                viewModel.toggleFavorite(for: cocktail)
                            }) {
                                if(cocktail.isFavorite){
                                    Image(systemName: cocktail.isFavorite ? "heart.fill" : "heart")
                                        .foregroundColor(cocktail.isFavorite ? .red : .gray)
                                }
                               
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }

                .onChange(of: selectedFilter) { filter in
                    viewModel.loadCocktails(filter: filter)
                }
            }
            .navigationTitle("Cocktails")
            .onAppear {
                viewModel.loadCocktails(filter: selectedFilter)
            }
        }
    }
}

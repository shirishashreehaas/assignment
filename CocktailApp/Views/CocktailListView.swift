//
//  CocktailListView.swift
//  CocktailApp
//
//  Created by Venkat_test on 26/12/2024.
//

import SwiftUI

struct CocktailListView: View {
    @StateObject private var viewModel = CocktailViewModel(service: CocktailAPIService())
    @State private var selectedFilter = "Alcoholic"


    var body: some View {
        NavigationView {
            // Display loader, error and retry option
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading Cocktails...")
                        .padding()
                        .foregroundColor(.gray)

                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 20) {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)

                        Button(action: {
                            viewModel.loadCocktails(filter: "Alcoholic")
                        }) {
                            Text("Retry")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    // Display the picker and the list of cocktails if data is successfully loaded
                } else {
                    // Filter picker for selecting "Alcoholic" or "Non-Alcoholic"
                Picker("Filter", selection: $selectedFilter) {
                    Text("Alcoholic").tag("Alcoholic")
                    Text("Non-Alcoholic").tag("Non_Alcoholic")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List(viewModel.cocktails) { cocktail in
                    NavigationLink(destination: CocktailDetailView(cocktailListViewModel: viewModel, cocktailDetailViewModel: CocktailDetailsViewModel(apiService: CocktailAPIService()), cocktail: cocktail))  {
                        // Display cocktails list
                        HStack {

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
                    // Trigger load cocktails when the filter changes
                .onChange(of: selectedFilter) { filter in
                    viewModel.loadCocktails(filter: filter)
                }
            }
            }
            .navigationTitle("Cocktails")
            .onAppear {
                viewModel.loadCocktails(filter: selectedFilter)
            }
        }
    }
}


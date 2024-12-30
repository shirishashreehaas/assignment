//
//  CocktailAppApp.swift
//  CocktailApp
//
//  Created by Venkat_test on 26/12/2024.
//
import SwiftUI

@main
struct CocktailApp: App {
    var body: some Scene {
        let isTesting = ProcessInfo.processInfo.environment["UITesting"] == "true"
        let apiService: CocktailAPIServiceProtocol = isTesting ? MockCocktailAPIService() : CocktailAPIService()

        WindowGroup {
            CocktailListView()
        }
    }
}

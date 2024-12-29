//
//  CocktailViewModelTests.swift
//  CocktailAppTests
//
//  Created by Venkat_test on 27/12/2024.
//

import XCTest
import Combine
@testable import CocktailApp

class CocktailViewModelTests: XCTestCase {
    var viewModel: CocktailViewModel!
    var mockService: MockCocktailAPIService!
    var cancellables: Set<AnyCancellable>!
    let testFavoritesKey = "testFavoriteCocktailIDs"

    override func setUp() {
        super.setUp()
        mockService = MockCocktailAPIService()
        viewModel = CocktailViewModel(service: mockService)
        cancellables = []
        UserDefaults.standard.removeObject(forKey: testFavoritesKey)

    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        UserDefaults.standard.removeObject(forKey: testFavoritesKey)

        super.tearDown()
    }

    func testLoadCocktailsSuccess() {
        mockService.mockCocktails = [
            CocktailItem(idDrink: "1", strDrink: "Margarita", strDrinkThumb: "https://example.com/margarita.jpg"),
            CocktailItem(idDrink: "2", strDrink: "Mojito", strDrinkThumb: "https://example.com/mojito.jpg")
        ]

        let expectation = XCTestExpectation(description: "Fetch cocktails successfully")
        viewModel.$cocktails
            .dropFirst()
            .sink { cocktails in
                XCTAssertEqual(cocktails.count, 2)
                XCTAssertEqual(cocktails[0].strDrink, "Margarita")
                XCTAssertEqual(cocktails[1].strDrink, "Mojito")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadCocktails(filter: "Alcoholic")
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadCocktailsFailure() {
        mockService.shouldFail = true

        let expectation = XCTestExpectation(description: "Fetch cocktails fails")
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadCocktails(filter: "Alcoholic")
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testToggleFavorite() {

            let cocktailIem = CocktailItem(idDrink: "2", strDrink: "Mojito", strDrinkThumb: "https://example.com/mojito.jpg")
            viewModel.toggleFavorite(for: cocktailIem)
            XCTAssertTrue(viewModel.favoriteCocktailIDs.contains(cocktailIem.id))
            XCTAssertTrue(viewModel.cocktails.first?.isFavorite ?? true)
        }
    
    func testFavoritesPersistence() {
            let cocktailIem = CocktailItem(idDrink: "2", strDrink: "Mojito", strDrinkThumb: "https://example.com/mojito.jpg")
            viewModel.toggleFavorite(for: cocktailIem)
            viewModel.loadFavorites()
            XCTAssertTrue(viewModel.favoriteCocktailIDs.contains(cocktailIem.id))
       }
    func testLoadCocktailDetailsSuccess() {
        // Given
        let mockDetails = CocktailDetails(
            idDrink: "1",
            strDrink: "Margarita",
            strInstructions: "Mix ingredients and serve over ice.",
            strIngredient1: "Tequila",
            strIngredient2: "Triple sec",
            strIngredient3: "Lime juice",
            strDrinkThumb: "https://example.com/margarita.jpg"
        )
      
        mockService.mockCocktailDetails = mockDetails

        // When
        let expectation = XCTestExpectation(description: "Fetch cocktail details successfully")
        viewModel.$cocktailDetails
            .dropFirst() // Ignore the initial nil value
            .sink(receiveValue: { details in
                XCTAssertEqual(details?.strDrink, "Margarita")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.loadCocktailDetails(id: "1")

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadCocktailDetailsFailure() {
        // Given
        mockService.shouldFail = true

        // When
        let expectation = XCTestExpectation(description: "Fetch cocktail details fails")
        viewModel.$errorMessage
            .dropFirst() // Ignore the initial nil value
            .sink(receiveValue: { errorMessage in
                XCTAssertNotNil(errorMessage)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.loadCocktailDetails(id: "1")

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}

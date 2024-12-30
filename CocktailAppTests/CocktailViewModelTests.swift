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

        let expectation = XCTestExpectation(description: "Fetch cocktails successfully")
        viewModel.$cocktails
            .dropFirst()
            .sink { cocktails in
                XCTAssertEqual(cocktails.count, 2)
                XCTAssertEqual(cocktails[0].strDrink, "Mock Margarita")
                XCTAssertEqual(cocktails[1].strDrink, "Mock Mojito")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadCocktails(filter: "Alcoholic")
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadCocktailsFailure() {
        mockService.shouldFail = true
        mockService.errorToThrow = APIError.invalidResponse

        // Act: Trigger fetching details
        viewModel.loadCocktails(filter: "Alcoholic")

        // Assert: Ensure error message is set
        let expectation = XCTestExpectation(description: "Error message should be set")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.viewModel.cocktails.isEmpty, "Cocktail list should be empty when an error occurs.")
            XCTAssertFalse(self.viewModel.isLoading, "Loading state should be false after API call.")
            XCTAssertEqual(self.viewModel.errorMessage, "Invalid response from server.", "Error message should match APIError description.")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
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

}

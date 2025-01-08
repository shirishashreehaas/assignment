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

    /// Tests that cocktails are successfully loaded from the API and updates the view model.
    func testLoadCocktailsSuccess() {

        let expectation = XCTestExpectation(description: "Fetch cocktails successfully")
        
        // Subscribe to the `cocktails` publisher in the view model
        viewModel.$cocktails
            .dropFirst()
            .sink { cocktails in
                XCTAssertEqual(cocktails.count, 2)
                XCTAssertEqual(cocktails[0].strDrink, "Mock Margarita")
                XCTAssertEqual(cocktails[1].strDrink, "Mock Mojito")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Act: Trigger the API call
        viewModel.loadCocktails(filter: "Alcoholic")
        
        // Wait for expectations to be fulfilled
        wait(for: [expectation], timeout: 2.0)
    }

    /// Tests that the view model handles API failures correctly and displays an error message.
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
        
        // Wait for expectations to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }
    
    /// Tests toggling a cocktail as a favorite and ensures the state is updated correctly.
    func testToggleFavorite() {

            let cocktailIem = CocktailItem(idDrink: "2", strDrink: "Mojito", strDrinkThumb: "https://example.com/mojito.jpg")
        
            // Act: Toggle the cocktail as a favorite
            viewModel.toggleFavorite(for: cocktailIem)
        
            // Assert: Verify that the cocktail ID is stored in the favorites list
            XCTAssertTrue(viewModel.favoriteCocktailIDs.contains(cocktailIem.id))
            XCTAssertTrue(viewModel.cocktails.first?.isFavorite ?? true)
        }
    
    /// Tests that favorites are persisted correctly in `UserDefaults`.
    func testFavoritesPersistence() {
            let cocktailIem = CocktailItem(idDrink: "2", strDrink: "Mojito", strDrinkThumb: "https://example.com/mojito.jpg")
        
            // Act: Toggle the cocktail as a favorite and reload favorites
            viewModel.toggleFavorite(for: cocktailIem)
            viewModel.loadFavorites()
        
            // Assert: Verify that the favorite persists across reloads
            XCTAssertTrue(viewModel.favoriteCocktailIDs.contains(cocktailIem.id))
       }

}

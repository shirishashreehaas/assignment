//
//  CocktailViewModelTests.swift
//  CocktailAppTests
//
//  Created by Venkat_test on 27/12/2024.
//

import XCTest
import Combine
@testable import CocktailApp

class CocktailDetailsViewModelTests: XCTestCase {
    var viewModel: CocktailDetailsViewModel!
    var mockService: MockCocktailAPIService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockCocktailAPIService()
        viewModel = CocktailDetailsViewModel(apiService: mockService)
        cancellables = []

    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil

        super.tearDown()
    }

   
    
    /// Tests that cocktail details are successfully loaded from the API and update the view model.
    func testLoadCocktailDetailsSuccess() {
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
        
        // Expectation to wait for the test to complete
        let expectation = XCTestExpectation(description: "Fetch cocktail details successfully")
        
        // Subscribe to the `cocktailDetails` publisher in the view model
        viewModel.$cocktailDetails
            .dropFirst() // Ignore the initial nil value
            .sink(receiveValue: { details in
                XCTAssertEqual(details?.strDrink, "Margarita")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Act: Trigger fetching details
        viewModel.loadCocktailDetails(id: "1")
        
        // Wait for expectations to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }

    /// Tests that the view model handles API failures correctly and displays an error message.
    func testLoadCocktailDetailsFailure() {
        
        // Arrange: Configure the mock service to simulate a failure
        mockService.shouldFail = true
        mockService.errorToThrow = APIError.invalidResponse

        // Act: Trigger fetching details
        viewModel.loadCocktailDetails(id: "1")

        // Assert: Ensure error message is set
        let expectation = XCTestExpectation(description: "Error message should be set")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNil(self.viewModel.cocktailDetails, "Cocktail details should be nil when an error occurs.")
            XCTAssertFalse(self.viewModel.isLoading, "Loading state should be false after API call.")
            XCTAssertEqual(self.viewModel.errorMessage, "Invalid response from server.", "Error message should match APIError description.")
            expectation.fulfill()
        }
        
        // Wait for expectations to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }
   
    
  
}

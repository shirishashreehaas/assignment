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

        let expectation = XCTestExpectation(description: "Fetch cocktail details successfully")
        viewModel.$cocktailDetails
            .dropFirst() // Ignore the initial nil value
            .sink(receiveValue: { details in
                XCTAssertEqual(details?.strDrink, "Margarita")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.loadCocktailDetails(id: "1")

        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadCocktailDetailsFailure() {
        
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

        wait(for: [expectation], timeout: 1.0)
    }
   
    
  
}

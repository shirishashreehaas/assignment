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

    override func setUp() {
        super.setUp()
        mockService = MockCocktailAPIService()
        viewModel = CocktailViewModel(service: mockService)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }

    func testLoadCocktailsSuccess() {
        // Given
        mockService.mockCocktails = [
            CocktailItem(idDrink: "1", strDrink: "Margarita", strDrinkThumb: "https://example.com/margarita.jpg"),
            CocktailItem(idDrink: "2", strDrink: "Mojito", strDrinkThumb: "https://example.com/mojito.jpg")
        ]

        // When
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
        
        // Then
        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadCocktailsFailure() {
        // Given
        mockService.shouldFail = true

        // When
        let expectation = XCTestExpectation(description: "Fetch cocktails fails")
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadCocktails(filter: "Alcoholic")
        
        // Then
        wait(for: [expectation], timeout: 2.0)
    }
}

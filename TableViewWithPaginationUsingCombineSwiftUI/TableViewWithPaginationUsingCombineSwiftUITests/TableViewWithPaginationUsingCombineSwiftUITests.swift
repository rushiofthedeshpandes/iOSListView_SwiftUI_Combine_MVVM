//
//  TableViewWithPaginationUsingCombineSwiftUITests.swift
//  TableViewWithPaginationUsingCombineSwiftUITests
//
//  Created by Rushikesh Deshpande on 25/04/24.
//


import XCTest
import Combine

@testable import TableViewWithPaginationUsingCombineSwiftUI

class ItemViewModelTests: XCTestCase {
    
    var viewModel: ItemViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = ItemViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchItems() {
        let expectation = XCTestExpectation(description: "Fetch items")
        
        viewModel.$isLoading
            .dropFirst() // Skip initial value
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                    XCTAssertFalse(self.viewModel.items.isEmpty)
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchItems()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testComputeHeavyTask() {
        let (result, timeTaken) = viewModel.computeHeavyTask(input: 1000000)
        
        XCTAssertNotNil(result)
        XCTAssertNotNil(timeTaken)
        XCTAssertGreaterThan(timeTaken, 0)
    }
    
    func testUpdateHeavyTaskResult() {
        let item = Item(id: 1, userId: 1, title: "Test", body: "Test Body")
        viewModel.items = [item]
        
        let result = 1000
        let timeTaken: TimeInterval = 0.5
        viewModel.updateHeavyTaskResult(for: item, result: result, timeTaken: timeTaken)
        
        XCTAssertEqual(viewModel.items.first?.heavyTaskResult, result)
        XCTAssertEqual(viewModel.items.first?.heavyTaskTimeTaken, timeTaken)
    }
    
    func testUpdateHeavyTaskResultIfNeeded() {
        let item = Item(id: 1, userId: 1, title: "Test", body: "Test Body")
        viewModel.items = [item]
        
        viewModel.updateHeavyTaskResultIfNeeded(for: item)
        
        XCTAssertNotNil(viewModel.items.first?.heavyTaskResult)
        XCTAssertNotNil(viewModel.items.first?.heavyTaskTimeTaken)
    }
}

//
//  TestLBCTests.swift
//  TestLBCTests
//
//  Created by Radhouani Malek on 25/06/2022.
//

import XCTest
@testable import TestLBC
import LBCNetwork

class TestLBCTests: XCTestCase {
  
  let networkProvider = NetworkProviderMock(with: [item1, item2, item3], categories: [itemCategory1, itemCategory2])

  func testSortedData() throws {
    
    let viewModel = ItemsListViewModel(with: self.networkProvider)
    
    viewModel.handle(action: .fetchItems)

    XCTAssertEqual(viewModel.currentListItems.value.count, 3, "Items are not fully loaded")
    
    XCTAssertEqual(sortedUrgetFirstlistItems, viewModel.currentListItems.value, "items are not sorted")
  }
  
  func testFilter() throws {
    let viewModel = ItemsListViewModel(with: self.networkProvider)
    
    viewModel.handle(action: .fetchItems)
    viewModel.handle(action: .filter(type: .category(itemCategory1)))
    
    XCTAssertEqual(viewModel.currentListItems.value.count, 1, "this filter should keep only one item in the list")

    let expectedListItem = ListItem(item: item1, category: itemCategory1)
    
    XCTAssertEqual(expectedListItem, viewModel.currentListItems.value.first, "wrong filter result")
  }
}

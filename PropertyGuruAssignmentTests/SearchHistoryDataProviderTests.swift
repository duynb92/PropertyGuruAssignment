//
//  SearchHistoryDataProviderTests.swift
//  PropertyGuruAssignmentTests
//
//  Created by Duy Nguyen on 5/14/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import XCTest
@testable import PropertyGuruAssignment

class SearchHistoryDataProviderTests: XCTestCase {
    
    var searchHistoryDataProvider: SearchHistoryDataProvider!
    var mockSearchHistoryManager: SearchHistoryManager!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        mockSearchHistoryManager = SearchHistoryManager()
        mockSearchHistoryManager.searchHistoryKey = "MOCK_TEST_KEY"
        searchHistoryDataProvider = SearchHistoryDataProvider(mockSearchHistoryManager)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        searchHistoryDataProvider = nil
        mockSearchHistoryManager = nil
        super.tearDown()
    }
}

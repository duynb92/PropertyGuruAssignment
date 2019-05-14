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
    
    class MockSearchHistoryManager: SearchHistoryManagerType {
        
        var appendSearchHistoryCalled = false
        var getSearchHistoriesCalled = false
        var getReversedSearchHistoryCalled = false
        var clearSearchHistoriesCalled = false
        
        var searchStrings: [String] = []
        
        func appendSearchHistory(_ searchString: String) {
            appendSearchHistoryCalled = true
        }
        
        func getSearchHistories() -> [String] {
            getSearchHistoriesCalled = true
            return []
        }
        
        func getReversedSearchHistory() -> [String] {
            getReversedSearchHistoryCalled = true
            return searchStrings.reversed()
        }
        
        func clearSearchHistories() {
            clearSearchHistoriesCalled = true
        }
    }
    
    var searchHistoryDataProvider: SearchHistoryDataProvider!
    var mockSearchHistoryManager: MockSearchHistoryManager!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        mockSearchHistoryManager = MockSearchHistoryManager()
        searchHistoryDataProvider = SearchHistoryDataProvider()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        searchHistoryDataProvider = nil
        mockSearchHistoryManager = nil
        super.tearDown()
    }
    
    func test_appendSearchHistory_shouldCallSearchHistoryManager() {
        //given
        searchHistoryDataProvider.searchHistoryManager = mockSearchHistoryManager
        
        //when
        searchHistoryDataProvider.appendSearchHistory("TEST")
        
        //then
        XCTAssertTrue(mockSearchHistoryManager.appendSearchHistoryCalled)
    }
    
    func test_getSearchHistory_withValidIndex_shouldCallReversedSearchHistory() {
        //given
        mockSearchHistoryManager.searchStrings = ["searchString1","searchString2", "searchString3", "searchString4", "searchString5"]
        searchHistoryDataProvider.searchHistoryManager = mockSearchHistoryManager
        
        //when
        let _ = searchHistoryDataProvider.getSearchHistory(at: 1)
        
        //then
        XCTAssertTrue(mockSearchHistoryManager.getReversedSearchHistoryCalled)
    }
    
    func test_getSearchHistory_withInvalidIndex_shouldCallReversedSearchHistory() {
        //given
        searchHistoryDataProvider.searchHistoryManager = mockSearchHistoryManager
        
        //when
        let _ = searchHistoryDataProvider.getSearchHistory(at: -1)
        
        //then
        XCTAssertFalse(mockSearchHistoryManager.getReversedSearchHistoryCalled)
    }
    
    func test_getSearchHistory_withValidIndex_shouldReturnString() {
        //given
        mockSearchHistoryManager.searchStrings = ["searchString1","searchString2", "searchString3", "searchString4", "searchString5"]
        searchHistoryDataProvider.searchHistoryManager = mockSearchHistoryManager
        
        //when
        let searchHistory = searchHistoryDataProvider.getSearchHistory(at: 1)
        
        //then
        XCTAssertNotNil(searchHistory)
    }
    
    func test_getSearchHistory_withInvalidIndex_shouldReturnString() {
        //given
        mockSearchHistoryManager.searchStrings = ["searchString1","searchString2", "searchString3", "searchString4", "searchString5"]
        searchHistoryDataProvider.searchHistoryManager = mockSearchHistoryManager
        
        //when
        let searchHistory = searchHistoryDataProvider.getSearchHistory(at: -1)
        
        //then
        XCTAssertNil(searchHistory)
    }
    
    func test_getSearchHistory_shouldReturnFromReversedOrder() {
        //given
        mockSearchHistoryManager.searchStrings = ["searchString1","searchString2", "searchString3", "searchString4", "searchString5"]
        searchHistoryDataProvider.searchHistoryManager = mockSearchHistoryManager
        
        //when
        let searchHistory = searchHistoryDataProvider.getSearchHistory(at: 0)
        
        //then
        XCTAssertNotNil(searchHistory)
        XCTAssertTrue(searchHistory == "searchString5")
    }
}

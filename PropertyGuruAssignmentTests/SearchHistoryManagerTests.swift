//
//  SearchHistoryManagerTests.swift
//  PropertyGuruAssignmentTests
//
//  Created by Duy Nguyen on 5/12/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import XCTest
@testable import PropertyGuruAssignment

class SearchHistoryManagerTests: XCTestCase {
    
    var searchHistoryManager: SearchHistoryManager!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        searchHistoryManager = SearchHistoryManager()
        searchHistoryManager.searchHistoryKey = "MOCK_SEARCH_HISTORY_KEY"
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        searchHistoryManager.clearSearchHistories()
        searchHistoryManager = nil
        super.tearDown()
    }

    func test_appendSearchHistory_withValidString_shouldExistInGet() {
        //given
        let searchString = "new search string"
        
        //when
        searchHistoryManager.appendSearchHistory(searchString)
        
        //then
        let searchHistories = searchHistoryManager.getSearchHistories()
        
        XCTAssertTrue(searchHistories.count > 0)
        XCTAssertTrue(searchHistories[0] == searchString)
    }
    
    func test_appendSearchHistory_withEmptyString_shouldNotExistInGet() {
        //given
        let searchString = ""
        
        //when
        searchHistoryManager.appendSearchHistory(searchString)
        
        //then
        let searchHistories = searchHistoryManager.getSearchHistories()
        
        XCTAssertTrue(searchHistories.count == 0)
    }
    
    func test_appendSearchHistory_withOnlySpacesString_shouldNotExistInGet() {
        //given
        let searchString = "   "
        
        //when
        searchHistoryManager.appendSearchHistory(searchString)
        
        //then
        let searchHistories = searchHistoryManager.getSearchHistories()
        
        XCTAssertTrue(searchHistories.count == 0)
    }
    
    func test_appendSearchHistory_withMoreThanMaximumCount_shouldReturnOnlyMaximumCount() {
        //given
        let numberToAdd = 11
        
        //when
        for i in 0...numberToAdd {
            let searchString = "searchString\(i)"
            searchHistoryManager.appendSearchHistory(searchString)
        }
        
        //then
        let searchHistories = searchHistoryManager.getSearchHistories()
        
        XCTAssertTrue(searchHistories.count == searchHistoryManager.maximumSearchCount)
    }
    
    func test_clearSearchHistory_after_shouldReturnEmpty() {
        //given
        searchHistoryManager.clearSearchHistories()
        
        //when
        let searchHistories = searchHistoryManager.getSearchHistories()
        
        //then
        XCTAssertTrue(searchHistories.count == 0)
    }
    
    func test_getSearchHistories_withNoStringAppend_shouldReturnEmpty() {
        //given
        
        //when
        let searchHistories = searchHistoryManager.getSearchHistories()
        
        //then
        XCTAssertTrue(searchHistories.count == 0)
    }
    
    func test_getSearchHistories_withAppendSomeStrings_shouldReturnSomeStrings() {
        //given
        let numberToAdd = 5
        
        //when
        for i in 1...numberToAdd {
            let searchString = "searchString\(i)"
            searchHistoryManager.appendSearchHistory(searchString)
        }
        
        //then
        let searchHistories = searchHistoryManager.getSearchHistories()
        
        XCTAssertTrue(searchHistories.count == numberToAdd)
    }

    func test_getReversedSearchHistories__withEmptySearchHistories_shouldReturnEmpty() {
        //given
        
        //when
        let reversedSearchHistories = searchHistoryManager.getReversedSearchHistory()
        
        //then
        XCTAssertNotNil(reversedSearchHistories)
        XCTAssertTrue(reversedSearchHistories.count == 0)
    }
    
    func test_getReversedSearchHistories__withSearchHistories_shouldReturnInReversed() {
        //given
        let numberToAdd = 5
        
        //when
        for i in 1...numberToAdd {
            let searchString = "searchString\(i)"
            searchHistoryManager.appendSearchHistory(searchString)
        }
        
        //then
        let reversedSearchHistories = searchHistoryManager.getReversedSearchHistory()
        XCTAssertNotNil(reversedSearchHistories)
        XCTAssertTrue(reversedSearchHistories.count > 0)
        XCTAssertTrue(reversedSearchHistories.first == "searchString\(numberToAdd)")
        XCTAssertTrue(reversedSearchHistories.last == "searchString1")
    }
}

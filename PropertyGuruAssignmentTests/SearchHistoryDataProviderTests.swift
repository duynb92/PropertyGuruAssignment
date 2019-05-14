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
    
    class MockSearchHistoryDataProviderDeleagte : SearchHistoryDataProviderDelegate {
        var didSearchArticleCalled = false
        func didSearchArticle(_ searchString: String) {
            didSearchArticleCalled = true
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
    
    func test_getSearchHistory_withInvalidIndex_shouldReturnNil() {
        //given
        mockSearchHistoryManager.searchStrings = ["searchString1","searchString2", "searchString3", "searchString4", "searchString5"]
        searchHistoryDataProvider.searchHistoryManager = mockSearchHistoryManager
        
        //when
        let searchHistory1 = searchHistoryDataProvider.getSearchHistory(at: -1)
        let searchHistory2 = searchHistoryDataProvider.getSearchHistory(at: 8)
        
        //then
        XCTAssertNil(searchHistory1)
        XCTAssertNil(searchHistory2)
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
    
    func test_collectionViewDidSelectItem_withValidIndexPath_shouldCallAppendSearchHistory(){
        //given
        mockSearchHistoryManager.searchStrings = ["searchString1","searchString2", "searchString3", "searchString4", "searchString5"]
        searchHistoryDataProvider.searchHistoryManager = mockSearchHistoryManager
        
        //when
        searchHistoryDataProvider.collectionView(UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout()), didSelectItemAt: IndexPath(row: 0, section: 0))
        
        //then
        XCTAssertTrue(mockSearchHistoryManager.appendSearchHistoryCalled)
    }
    
    func test_collectionViewDidSelectItem_withValidIndexPath_withDelegate_shouldCallDidSearchArticle(){
        //given
        mockSearchHistoryManager.searchStrings = ["searchString1","searchString2", "searchString3", "searchString4", "searchString5"]
        searchHistoryDataProvider.searchHistoryManager = mockSearchHistoryManager
        let mockSearchHistoryDataProviderDelegate = MockSearchHistoryDataProviderDeleagte()
        searchHistoryDataProvider.delegate = mockSearchHistoryDataProviderDelegate
        
        //when
        searchHistoryDataProvider.collectionView(UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout()), didSelectItemAt: IndexPath(row: 0, section: 0))
        
        //then
        XCTAssertTrue(mockSearchHistoryDataProviderDelegate.didSearchArticleCalled)
    }
    
    func test_collectionViewDidSelectItem_withInvalidIndexPath_shouldNotCallAppendSearchHistory(){
        //given
        searchHistoryDataProvider.searchHistoryManager = mockSearchHistoryManager
        
        //when
        searchHistoryDataProvider.collectionView(UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout()), didSelectItemAt: IndexPath(row: -2, section: 0))
        
        //then
        XCTAssertFalse(mockSearchHistoryManager.appendSearchHistoryCalled)
    }
}

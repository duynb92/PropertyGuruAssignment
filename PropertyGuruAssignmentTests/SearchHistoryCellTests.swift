//
//  SearchHistoryCellTests.swift
//  PropertyGuruAssignmentTests
//
//  Created by Duy Nguyen on 5/16/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import XCTest
@testable import PropertyGuruAssignment

class SearchHistoryCellTests: XCTestCase {
    
    class MockSearchHistoryDataProvider: NSObject, SearchHistoryDataProviderType {
        var delegate: SearchHistoryDataProviderDelegate?
        
        func appendSearchHistory(_ searchString: String) {
        }
        
        func getSearchHistory(at index: Int) -> String? {
            return nil
        }
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 2
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "SearchHistoryCollectionViewCell", for: indexPath) as! SearchHistoryCollectionViewCell
            cell.setupCell("mockSearchString")
            return cell
        }
    }
    
    var searchHistoryCell : SearchHistoryCollectionViewCell!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let articlesViewController = storyboard.instantiateViewController(withIdentifier: "ArticlesViewController") as? ArticlesViewController
        _ = articlesViewController!.view
        let mockSearchHistoryDataProvider = MockSearchHistoryDataProvider()
        articlesViewController?.searchHistoryDataProvider = mockSearchHistoryDataProvider
        searchHistoryCell = articlesViewController!.searchHistoryDataProvider.collectionView(articlesViewController!.colSearchHistories, cellForItemAt: IndexPath(row: 0, section: 0)) as? SearchHistoryCollectionViewCell
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        searchHistoryCell = nil
        super.tearDown()
    }

    func test_setupCell_withValidSearchString_shouldUpdateLabelText() {
        //given
        let searchString = "searchString"
        
        //when
        searchHistoryCell.setupCell(searchString)
        
        //then
        XCTAssertNotNil(searchHistoryCell.lbHistory.text)
        XCTAssertTrue(searchHistoryCell.lbHistory.text == searchString)
    }

}

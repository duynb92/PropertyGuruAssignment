//
//  ArticlesViewControllerTests.swift
//  PropertyGuruAssignmentTests
//
//  Created by Duy Nguyen on 5/15/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import XCTest
@testable import PropertyGuruAssignment

class ArticlesViewControllerTests: XCTestCase {
    
    class MockArticleDataProvider: NSObject, ArticleDataProviderType {
        var getArticlesCalled = false
        var getArticlesCountCalled = false
        var getArticleCalled = false
        var clearArticlesCalled = false
        var collectionViewNumberOfItemsCalled = false
        var collectionViewCellForItemCalled = false
        var articlesCount = 0
        
        func fetchArticles(query: String?, page: Int, completion: @escaping (APIResult<[Article]>) -> Void) {
            getArticlesCalled = true
        }
        
        func getArticlesCount() -> Int {
            getArticlesCountCalled = true
            return articlesCount
        }
        
        func getArticle(at indexPath: IndexPath) -> Article? {
            getArticleCalled = true
            return nil
        }
        
        func clearArticles() {
            clearArticlesCalled = true
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            collectionViewNumberOfItemsCalled = true
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            collectionViewCellForItemCalled = true
            return UICollectionViewCell(frame: CGRect.zero)
        }
    }
    
    class MockCustomActivityIndicatorView: CustomActivityIndicatorView {
        var toogleCalled = false
        override func toogle() {
            toogleCalled = true
        }
    }
    
    var articlesViewController: ArticlesViewController!
    var mockArticleDataProvider: MockArticleDataProvider!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        articlesViewController = storyboard.instantiateViewController(withIdentifier: "ArticlesViewController") as? ArticlesViewController
        _ = articlesViewController.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        articlesViewController = nil
        mockArticleDataProvider = nil
        super.tearDown()
    }
    
    func test_doSearchArticles_withEmptyQuery_shouldSetQueryToNil() {
        //given
        let query = ""
        
        //when
        articlesViewController.doSearchArticle(query)
        
        //then
        XCTAssertNil(articlesViewController.query)
    }
    
    func test_doSearchArticles_withQuery_shouldCallfetchArticles() {
        //given
        let query = "aaa"
        mockArticleDataProvider = MockArticleDataProvider()
        articlesViewController.articleDataProvider = mockArticleDataProvider
        
        //when
        articlesViewController.doSearchArticle(query)
        
        //then
        XCTAssertNotNil(articlesViewController.query)
        XCTAssertTrue(mockArticleDataProvider.getArticlesCalled)
    }
    
    func test_doSearchArticles_withQuery_shouldCallClearArticles() {
        //given
        let query = "aaa"
        mockArticleDataProvider = MockArticleDataProvider()
        articlesViewController.articleDataProvider = mockArticleDataProvider
        
        //when
        articlesViewController.doSearchArticle(query)
        
        //then
        XCTAssertNotNil(articlesViewController.query)
        XCTAssertTrue(mockArticleDataProvider.clearArticlesCalled)
    }
    
    func test_searchBarBeginEditing_shouldSetIsSearchingToTrue() {
        //given
        let mockSearchBar = UISearchBar(frame: CGRect.zero)
        
        //when
        let _ = articlesViewController.searchBarShouldBeginEditing(mockSearchBar)
        
        //then
        XCTAssertTrue(articlesViewController.isSearching)
    }
    
    func test_searchBarSearchButtonClicked_shouldSetIsSearchingToFalse() {
        //given
        let mockSearchBar = UISearchBar(frame: CGRect.zero)
        
        //when
        articlesViewController.searchBarSearchButtonClicked(mockSearchBar)
        
        //then
        XCTAssertFalse(articlesViewController.isSearching)
    }
    
    func test_searchBarCancelButtonClicked_shouldSetIsSearchingToFalse() {
        //given
        let mockSearchBar = UISearchBar(frame: CGRect.zero)
        
        //when
        articlesViewController.searchBarCancelButtonClicked(mockSearchBar)
        
        //then
        XCTAssertFalse(articlesViewController.isSearching)
    }
    
    func test_searchBarTextDidEndEditing_shouldSetIsSearchingToFalse() {
        //given
        let mockSearchBar = UISearchBar(frame: CGRect.zero)
        
        //when
        articlesViewController.searchBarTextDidEndEditing(mockSearchBar)
        
        //then
        XCTAssertFalse(articlesViewController.isSearching)
    }
    
    func test_stopSearching_shouldSetIsSearchingToFalse() {
        //given
        
        //when
        articlesViewController.stopSearching()
        
        //then
        XCTAssertFalse(articlesViewController.isSearching)
    }
    
    func test_isLastPageOfArticles_shouldReturnTrue() {
        //given
        articlesViewController.page = 1
        mockArticleDataProvider = MockArticleDataProvider()
        mockArticleDataProvider.articlesCount = 15
        articlesViewController.articleDataProvider = mockArticleDataProvider
        
        //when
        let isLastPageOfArticles = articlesViewController.isLastPageOfArticles()
        
        //then
        XCTAssertTrue(isLastPageOfArticles)
    }
    
    func test_stillHaveArticlesToGet_shouldReturnFalse() {
        //given
        articlesViewController.page = 1
        mockArticleDataProvider = MockArticleDataProvider()
        mockArticleDataProvider.articlesCount = 20
        articlesViewController.articleDataProvider = mockArticleDataProvider
        
        //when
        let isLastPageOfArticles = articlesViewController.isLastPageOfArticles()
        
        //then
        XCTAssertFalse(isLastPageOfArticles)
    }
}

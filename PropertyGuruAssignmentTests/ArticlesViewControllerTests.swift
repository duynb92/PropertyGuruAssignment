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
        
        func getArticles(query: String?, page: Int, completion: @escaping (APIResult<[Article]>) -> Void) {
            getArticlesCalled = true
        }
        
        func getArticlesCount() -> Int {
            getArticlesCountCalled = true
            return 0
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
            return UICollectionViewCell()
        }
    }
    
    var articlesViewController: ArticlesViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        articlesViewController = storyboard.instantiateViewController(withIdentifier: "ArticlesViewController") as? ArticlesViewController
       // _ = articlesViewController.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        articlesViewController = nil
        super.tearDown()
    }
    
//    func test_viewDidLoad_shouldCallGetArticles() {
//        //given
//        _ = articlesViewController.view
//        let mockArticleDataProvider = MockArticleDataProvider()
//        articlesViewController.articleDataProvider = mockArticleDataProvider
//
//        //when
//
//
//        //then
//        XCTAssertTrue(mockArticleDataProvider.getArticlesCalled)
//    }

}

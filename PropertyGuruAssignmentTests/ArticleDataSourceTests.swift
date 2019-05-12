//
//  ArticleDataSourceTests.swift
//  PropertyGuruAssignmentTests
//
//  Created by Duy Nguyen on 5/13/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import XCTest
@testable import PropertyGuruAssignment

class ArticleDataSourceTests: XCTestCase {

    class MockArticleManager : ArticleManager {
        override func getArticles(query: String?, page: Int?, completion: @escaping (APIResult<[Article]>) -> Void) {
            articles = [
                Article(id: "id", title: "title", snippet: "snippet", date: Date(), images: [], webUrl: "webUrl"),
                Article(id: "id", title: "title", snippet: "snippet", date: Date(), images: [], webUrl: "webUrl"),
                Article(id: "id", title: "title", snippet: "snippet", date: Date(), images: [], webUrl: "webUrl"),
            ]
        }
    }
    
    var articleDataSource: ArticleDataSource!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        articleDataSource = ArticleDataSource(MockArticleManager())
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        articleDataSource = nil
        super.tearDown()
    }
    
    func test_getArticle_withValidIndex_shouldReturnArticle() {
        //given
        articleDataSource.getArticles(query: "test", page: 0) { (result) in
            
        }
        
        //when
        let article = articleDataSource.getArticle(at: IndexPath(row:0,section:0))
        
        //then
        XCTAssertNotNil(article)
    }
    
    func test_getArticle_withInvalidIndex_shouldReturnNil() {
        //given
        articleDataSource.getArticles(query: "test", page: 0) { (result) in
            
        }
        
        //when
        let article = articleDataSource.getArticle(at: IndexPath(row:-2,section:0))
        
        //then
        XCTAssertNil(article)
    }
    
    func test_clearArticles_shouldReturnEmpty() {
        //given
        articleDataSource.getArticles(query: "test", page: 0) { (result) in
            
        }
        
        //when
        articleDataSource.clearArticles()
        
        //then
        let articleCount = articleDataSource.getArticlesCount()
        XCTAssertTrue(articleCount == 0)
    }
}

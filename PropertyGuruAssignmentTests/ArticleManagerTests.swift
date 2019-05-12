//
//  ArticleManagerTests.swift
//  PropertyGuruAssignmentTests
//
//  Created by Duy Nguyen on 5/12/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import XCTest
@testable import PropertyGuruAssignment

class ArticleManagerTests: XCTestCase {
    
    var articleManager: ArticleManager!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        articleManager = ArticleManager()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        articleManager = nil
        super.tearDown()
    }

    func test_getArticles_withQueryAndPage_shouldReturnArticles() {
        //given
        let givenQuery = "election"
        let givenPage = 0
        
        //when
        let expectation = self.expectation(description: "testGetArtices")
        
        var articles : [Article]?
        
        articleManager.getArticles(query: givenQuery, page: givenPage, completion: { (result) in
            switch result {
            case .success(let data):
                articles = data
                print(data)
            case .failure(let error):
                print(error)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 60, handler: nil)
        
        //then
        XCTAssertNotNil(articles)
        XCTAssertTrue((articles?.count)! > 0)
    }
    
    func test_getArticles_withoutQueryAndPage_shouldReturnArticles() {
        //given
        let givenQuery: String? = nil
        let givenPage: Int? = nil
        
        //when
        let expectation = self.expectation(description: "testGetArtices")
        
        var articles : [Article]?
        
        articleManager.getArticles(query: givenQuery, page: givenPage, completion: { (result) in
            switch result {
            case .success(let data):
                articles = data
                print(data)
            case .failure(let error):
                print(error)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 60, handler: nil)
        
        //then
        XCTAssertNotNil(articles)
        XCTAssertTrue((articles?.count)! > 0)
    }

    func test_getArticles_withQueryAndWithoutPage_shouldReturnArticles() {
        //given
        let givenQuery: String? = "election"
        let givenPage: Int? = nil
        
        //when
        let expectation = self.expectation(description: "testGetArtices")
        
        var articles : [Article]?
        
        articleManager.getArticles(query: givenQuery, page: givenPage, completion: { (result) in
            switch result {
            case .success(let data):
                articles = data
                print(data)
            case .failure(let error):
                print(error)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 60, handler: nil)
        
        //then
        XCTAssertNotNil(articles)
        XCTAssertTrue((articles?.count)! > 0)
    }
    
    func test_getArticles_withPageAndWithoutQuery_shouldReturnArticles() {
        //given
        let givenQuery: String? = nil
        let givenPage: Int? = 0
        
        //when
        let expectation = self.expectation(description: "testGetArtices")
        
        var articles : [Article]?
        
        articleManager.getArticles(query: givenQuery, page: givenPage, completion: { (result) in
            switch result {
            case .success(let data):
                articles = data
                print(data)
            case .failure(let error):
                print(error)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 60, handler: nil)
        
        //then
        XCTAssertNotNil(articles)
        XCTAssertTrue((articles?.count)! > 0)
    }
    
    func test_getArticles_whenFailed_shouldReturnError() {
        //given
        let givenQuery: String? = nil
        let givenPage: Int? = 999 //NYT API will fail when page is larger than 200
        
        //when
        let expectation = self.expectation(description: "testGetArtices")
        
        var articles : [Article]?
        var apiError: Error?
        
        articleManager.getArticles(query: givenQuery, page: givenPage, completion: { (result) in
            switch result {
            case .success(let data):
                articles = data
                print(data)
            case .failure(let error):
                apiError = error
                print(error)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 60, handler: nil)
        
        //then
        XCTAssertNil(articles)
        XCTAssertNotNil(apiError)
    }
}

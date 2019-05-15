//
//  ArticleDetailsViewControllerTests.swift
//  PropertyGuruAssignmentTests
//
//  Created by Duy Nguyen on 5/16/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import XCTest
@testable import PropertyGuruAssignment
import WebKit

class ArticleDetailsViewControllerTests: XCTestCase {

    var articleDetailsViewController: ArticleDetailsViewController!
    
    class MockCustomActivityIndicatorView: CustomActivityIndicatorView {
        var toogleCalled = false
        override func toogle() {
            toogleCalled = true
        }
    }
    
    class MockWebView : WKWebView {
        var loadUrlCalled = false
        override func load(_ request: URLRequest) -> WKNavigation? {
            loadUrlCalled = true
            return super.load(request)
        }
    }
    
    class MockArticleManager : ArticleManagerType {
        func fetchArticles(query: String?, page: Int, completion: @escaping (APIResult<[Article]>) -> Void) {
        }
        
        func getArticle(at index: Int) -> Article? {
            return nil
        }
        
        func clearArticles() {
        }
        
        func getArticles() -> [Article] {
            return [
                Article(id: "1", title: "title1", snippet: "snippet1", date: Date(), images: [], webUrl: "webUrl1"),
                Article(id: "2", title: "title2", snippet: "snippet2", date: Date(), images: [], webUrl: "webUrl2"),
                Article(id: "3", title: "title3", snippet: "snippet3", date: Date(), images: [], webUrl: "webUrl3"),
            ]
        }
    }
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        articleDetailsViewController = storyboard.instantiateViewController(withIdentifier: "ArticleDetailsViewController") as? ArticleDetailsViewController
        _ = articleDetailsViewController.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        articleDetailsViewController = nil
        super.tearDown()
    }

    func test_webViewLoadURL_withValidUrl_shouldCallLoadingIndicatorToogle() {
        //given
        let mockActivityIndicator = MockCustomActivityIndicatorView()
        articleDetailsViewController.loadingIndicator = mockActivityIndicator
        
        //when
        let urlRequest = URLRequest(url: URL(string:"http://www.google.com")!)
        articleDetailsViewController.webView.load(urlRequest)
        let expectation = self.expectation(description: "webViewLoadURL")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        //then
        XCTAssertTrue(mockActivityIndicator.toogleCalled)
    }
    
    func test_loadAricleDetails_withArticle_shouldCallLoadOnWebView() {
        //given
        let article = Article(id: "id", title: "title", snippet: "snippet", date: Date(), images: [], webUrl: "web_url")
        articleDetailsViewController.article = article
        let mockWebView = MockWebView()
        articleDetailsViewController.webView = mockWebView
        
        //when
        articleDetailsViewController.loadArticleDetails()
        
        //then
        XCTAssertTrue(mockWebView.loadUrlCalled)
    }
    
    func test_loadAricleDetails_withArticleNil_shouldCallLoadOnWebView() {
        //given
        let article: Article? = nil
        articleDetailsViewController.article = article
        let mockWebView = MockWebView()
        articleDetailsViewController.webView = mockWebView
        
        //when
        articleDetailsViewController.loadArticleDetails()
        
        //then
        XCTAssertFalse(mockWebView.loadUrlCalled)
    }
    
    func test_handleLeftSwipeGesture_withValidCondition_shouldCallLoadArticles() {
        //given
        let mockWebView = MockWebView()
        articleDetailsViewController.webView = mockWebView
        let leftSwipeGesture = UISwipeGestureRecognizer()
        leftSwipeGesture.direction = .left
        let mockArticleManager = MockArticleManager()
        articleDetailsViewController.articleManager = mockArticleManager
        
        //when
        let article = Article(id: "1", title: "title", snippet: "snippet", date: Date(), images: [], webUrl: "web_url")
        articleDetailsViewController.article = article
        articleDetailsViewController.handleSwipeGesture(gestureRecognizer: leftSwipeGesture)
        
        //then
        XCTAssertTrue(mockWebView.loadUrlCalled)
    }
    
    func test_handleLeftSwipeGesture_withInvalidCondition_shouldCallLoadArticles() {
        //given
        let mockWebView = MockWebView()
        articleDetailsViewController.webView = mockWebView
        let leftSwipeGesture = UISwipeGestureRecognizer()
        leftSwipeGesture.direction = .left
        let mockArticleManager = MockArticleManager()
        articleDetailsViewController.articleManager = mockArticleManager
        
        //when
        let article = Article(id: "3", title: "title", snippet: "snippet", date: Date(), images: [], webUrl: "web_url")
        articleDetailsViewController.article = article
        articleDetailsViewController.handleSwipeGesture(gestureRecognizer: leftSwipeGesture)
        
        //then
        XCTAssertFalse(mockWebView.loadUrlCalled)
        
        //when
        let article2 = Article(id: "5", title: "title", snippet: "snippet", date: Date(), images: [], webUrl: "web_url")
        articleDetailsViewController.article = article2
        articleDetailsViewController.handleSwipeGesture(gestureRecognizer: leftSwipeGesture)
        
        //then
        XCTAssertFalse(mockWebView.loadUrlCalled)
    }
    
}

//
//  ArticleTests.swift
//  PropertyGuruAssignmentTests
//
//  Created by Duy Nguyen on 5/12/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import XCTest
@testable import PropertyGuruAssignment

class ArticleTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_getImageUrl_withEmptyMultimedia_shouldReturnEmpty() {
        //given
        let article = Article(id: "id", title: "title", snippet: "snippet", date: Date(), images: [], webUrl: "webUrl")
        
        //when
        let imageUrl = article.getImageUrl()
        
        //then
        XCTAssertNotNil(imageUrl)
        XCTAssertTrue(imageUrl.isEmpty)
    }

    func test_getImageUrl_withMultimediaNotContainsThumbLarge_shouldReturnEmpty() {
        //given
        var multimedias = [
            ArticleMultimedia(type: "image", subType: "thumbLarge1", url: "url", width: 200, height: 200),
            ArticleMultimedia(type: "image", subType: "thumbLarge2", url: "url", width: 200, height: 200),
            ArticleMultimedia(type: "image", subType: "thumbLarge3", url: "url", width: 200, height: 200)
        ]
        var article = Article(id: "id", title: "title", snippet: "snippet", date: Date(), images: multimedias, webUrl: "webUrl")
        
        //when
        let imageUrl = article.getImageUrl()
        
        //then
        XCTAssertNotNil(imageUrl)
        XCTAssertTrue(imageUrl.isEmpty)
    }
    
    func test_getImageUrl_withMultimediaContainsThumbLarge_shouldReturnEmpty() {
        //given
        var multimedias = [
            ArticleMultimedia(type: "image", subType: "thumbLarge1", url: "url", width: 200, height: 200),
            ArticleMultimedia(type: "image", subType: "thumbLarge2", url: "url", width: 200, height: 200),
            ArticleMultimedia(type: "image", subType: "thumbLarge", url: "urlOfImage", width: 200, height: 200)
        ]
        var article = Article(id: "id", title: "title", snippet: "snippet", date: Date(), images: multimedias, webUrl: "webUrl")
        
        //when
        let imageUrl = article.getImageUrl()
        
        //then
        XCTAssertNotNil(imageUrl)
        XCTAssertFalse(imageUrl.isEmpty)
        XCTAssertTrue(imageUrl == "urlOfImage")
    }
    
    func test_getImageUrl_withThumbLargeAndTypeNotImage_shouldReturnEmpty() {
        //given
        var multimedias = [
            ArticleMultimedia(type: "image", subType: "thumbLarge1", url: "url", width: 200, height: 200),
            ArticleMultimedia(type: "image", subType: "thumbLarge2", url: "url", width: 200, height: 200),
            ArticleMultimedia(type: "video", subType: "thumbLarge", url: "urlOfImage", width: 200, height: 200)
        ]
        var article = Article(id: "id", title: "title", snippet: "snippet", date: Date(), images: multimedias, webUrl: "webUrl")
        
        //when
        let imageUrl = article.getImageUrl()
        
        //then
        XCTAssertNotNil(imageUrl)
        XCTAssertTrue(imageUrl.isEmpty)
    }
    
    func test_getImageUrl_withThumbLargeAndTypeImage_shouldReturnEmpty() {
        //given
        var multimedias = [
            ArticleMultimedia(type: "image", subType: "thumbLarge1", url: "url", width: 200, height: 200),
            ArticleMultimedia(type: "image", subType: "thumbLarge2", url: "url", width: 200, height: 200),
            ArticleMultimedia(type: "image", subType: "thumbLarge", url: "urlOfImage", width: 200, height: 200)
        ]
        var article = Article(id: "id", title: "title", snippet: "snippet", date: Date(), images: multimedias, webUrl: "webUrl")
        
        //when
        let imageUrl = article.getImageUrl()
        
        //then
        XCTAssertNotNil(imageUrl)
        XCTAssertFalse(imageUrl.isEmpty)
        XCTAssertTrue(imageUrl == "urlOfImage")
    }
}

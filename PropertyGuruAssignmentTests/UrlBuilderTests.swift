//
//  UrlBuilderTests.swift
//  PropertyGuruAssignmentTests
//
//  Created by Duy Nguyen on 5/12/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import XCTest
@testable import PropertyGuruAssignment

class UrlBuilderTests: XCTestCase {
    
    var urlBuilder: UrlBuilder!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        urlBuilder = UrlBuilder()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        urlBuilder = nil
        super.tearDown()
    }

    func test_buildUrl_withQuery_shouldReturnQueryInUrl() {
        //given
        let givenQuery = "newQuery"
        
        //when
        let url = urlBuilder.withQuery(query: givenQuery).build()
        
        //then
        XCTAssertNotNil(url)
        XCTAssertTrue(url.contains(givenQuery))
        XCTAssertTrue(url.contains("q=\(givenQuery)"))
    }
    
    func test_buildUrl_withPage_shouldReturnPageInUrl() {
        //given
        let givenPage = 1
        
        //when
        let url = urlBuilder.withPage(page: givenPage).build()
        
        //then
        XCTAssertNotNil(url)
        XCTAssertTrue(url.contains(String(givenPage)))
        XCTAssertTrue(url.contains("page=\(String(givenPage))"))
    }
    
    func test_buildUrl_withQueryAndPage_shouldReturnQueryAndPageInUrl() {
        //given
        let givenQuery = "newQuery"
        let givenPage = 1
        
        //when
        let url = urlBuilder.withPage(page: givenPage).withQuery(query: givenQuery).build()
        
        //then
        XCTAssertNotNil(url)
        XCTAssertTrue(url.contains(String(givenPage)))
        XCTAssertTrue(url.contains("page=\(String(givenPage))"))
        XCTAssertTrue(url.contains(givenQuery))
        XCTAssertTrue(url.contains("q=\(givenQuery)"))
    }

}

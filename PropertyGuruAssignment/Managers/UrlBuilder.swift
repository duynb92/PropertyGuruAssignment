//
//  UrlBuilder.swift
//  PropertyGuruAssignment
//
//  Created by Duy Nguyen on 5/12/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import Foundation

class UrlBuilder {
    private var page: Int?
    private var query: String?
    
    private func getRootUrl() -> String {
        return Constants.NYT_ROOT_API_URL + "?api-key=" + Constants.NYT_API_KEY
    }
    
    func withQuery(query: String?) -> UrlBuilder {
        if let query = query {
            self.query = query
        }
        return self
    }
    
    func withPage(page: Int?) -> UrlBuilder {
        if let page = page, page >= 0 {
            self.page = page
        }
        return self
    }
    
    func build() -> String {
        var url = getRootUrl()
        
        if let page = page {
            url += "&page=" + String(page)
        }
        
        if let query = query {
            url += "&q=" + query
        }
        
        return url
    }
}

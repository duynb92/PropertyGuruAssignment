//
//  Article.swift
//  PropertyGuruAssignment
//
//  Created by Duy Nguyen on 5/12/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import Foundation

class ArticlePayload : Decodable {
    var articles: [Article]
    
    enum CodingKeys: String, CodingKey {
        case response = "response", docs = "docs"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        articles = try response.decode([Article].self, forKey: .docs)
    }
}

class Article: Decodable {
    var id: String
    var title: String
    var snippet: String
    var date: Date
    var images: [ArticleMultimedia]
    var webUrl: String
    
    init(id: String, title: String, snippet: String, date: Date, images: [ArticleMultimedia], webUrl: String) {
        self.id = id
        self.title = title
        self.snippet = snippet
        self.date = date
        self.images = images
        self.webUrl = webUrl
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        
        snippet = try container.decode(String.self, forKey: .snippet)
        
        date = try container.decode(Date.self, forKey: .pubDate)
        
        let headline = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .headline)
        title = try headline.decode(String.self, forKey: .main)
        
        images = try container.decode([ArticleMultimedia].self, forKey: .multimedia)
        
        webUrl = try container.decode(String.self, forKey: .webUrl)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id", webUrl = "web_url", multimedia = "multimedia", headline = "headline", main = "main", snippet = "snippet", pubDate = "pub_date"
    }
    
    func getImageUrl() -> String {
        if images.count == 0 {
             return ""
        }
        
        var thumbs = images.filter{ $0.type == "image" && $0.subType == "thumbLarge" }
        if thumbs.count == 0 {
            return ""
        } else {
            return Constants.NYT_ROOT_URL + thumbs[0].url
        }
    }
}


class ArticleMultimedia: Decodable {
    var type: String
    var subType: String
    var url: String
    var width: Int
    var height: Int
    
    init(type: String, subType: String, url: String, width: Int, height: Int) {
        self.type = type
        self.subType = subType
        self.url = url
        self.width = width
        self.height = height
    }
}

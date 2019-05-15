//
//  ArticleManager.swift
//  PropertyGuruAssignment
//
//  Created by Duy Nguyen on 5/12/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import Foundation

//APIError enum which shows all possible errors
enum APIError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
}

//APIResult enum to show success or failure
enum APIResult<T> {
    case success(T)
    case failure(APIError)
}

protocol ArticleManagerType {
    
    /// Fetch NYT Articles with Query and Page
    ///
    /// - Parameters:
    ///   - query: string to filter results
    ///   - page: pagination of results (eg 0,1,2,3,...)
    ///   - completion: callback return list of Articles OR error
    func fetchArticles(query: String?, page: Int, completion: @escaping (APIResult<[Article]>) -> Void)
    
    /// Get article at index
    ///
    /// - Parameter index: index of article to get
    /// - Returns: If index is valid, return Article, otherwise nil
    func getArticle(at index: Int) -> Article?
    
    /// Clear all articles
    func clearArticles()
    
    /// Get articles
    func getArticles() -> [Article]
}

class ArticleManager: ArticleManagerType {
    
    static let shared = ArticleManager()
    
    var articles: [Article] = []
    
    /// Get NYT Articles with Query and Page
    ///
    /// - Parameters:
    ///   - query: string to filter results
    ///   - page: pagination of results (eg 0,1,2,3,...)
    ///   - completion: callback return list of Articles OR error
    func fetchArticles(query: String?, page: Int, completion: @escaping (APIResult<[Article]>) -> Void) {
        //build NYT url
        let url = UrlBuilder().withPage(page: page).withQuery(query: query).build()
        
        print("GET ARTICLES \(url)")
        
        //create the session object
        let session = URLSession.shared
        
        //create the URLRequest object
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.httpMethod = "GET"
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(APIResult.failure(APIError.networkError(error!)))
                return
            }
            
            guard let data = data else {
                completion(APIResult.failure(APIError.dataNotFound))
                return
            }
            
            do {
                //decodable object from data
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decodedObject = try decoder.decode(ArticlePayload.self, from: data)
                self.articles.append(contentsOf: decodedObject.articles)
                completion(APIResult.success(decodedObject.articles))
            } catch let error {
                completion(APIResult.failure(APIError.jsonParsingError(error as! DecodingError)))
            }
        })
        
        task.resume()
    }
    
    
    /// Get article at index
    ///
    /// - Parameter index: index of article to get
    /// - Returns: If index is valid, return Article, otherwise nil
    func getArticle(at index: Int) -> Article? {
        if (index >= 0) && (index < articles.count) {
            return articles[index]
        }
        return nil
    }

    /// Clear all articles
    func clearArticles() {
        self.articles = []
    }
    
    func getArticles() -> [Article] {
        return self.articles
    }
}

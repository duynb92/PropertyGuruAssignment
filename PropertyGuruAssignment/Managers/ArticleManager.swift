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

class ArticleManager {
    
    static let shared = ArticleManager()
    
    var articles: [Article] = []
    
    
    /// Clear all articles
    func clearArticles() {
        self.articles = []
    }
    
    /// Get NYT Articles with Query and Page
    ///
    /// - Parameters:
    ///   - query: string to filter results
    ///   - page: pagination of results (eg 0,1,2,3,...)
    ///   - completion: callback return list of Articles OR error
    func getArticles(query: String?, page: Int?, completion: @escaping (APIResult<[Article]>) -> Void) {
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

}

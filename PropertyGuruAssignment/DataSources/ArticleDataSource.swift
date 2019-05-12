//
//  ArticleDataSource.swift
//  PropertyGuruAssignment
//
//  Created by Duy Nguyen on 5/13/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit

class ArticleDataSource: NSObject, UICollectionViewDataSource {
    private var articleManager: ArticleManager!
    
    override init() {
        super.init()
        self.articleManager = ArticleManager.shared
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let articleManager = self.articleManager {
            return articleManager.articles.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "ArticleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
        cell.setupCell(self.articleManager.articles[indexPath.row])
        return cell
    }
    
    func getArticles(query: String?, page: Int?, completion: @escaping (APIResult<[Article]>) -> Void) {
        self.articleManager.getArticles(query: query, page: page, completion: completion)
    }
    
    func getArticlesCount() -> Int {
        if let articleManager = self.articleManager {
            return articleManager.articles.count
        }
        return 0
    }
    
    func getArticle(at indexPath: IndexPath) -> Article? {
        if let articleManager = self.articleManager {
            return articleManager.getArticle(at: indexPath.row)
        }
        return nil
    }
    
    func clearArticles() {
        self.articleManager.clearArticles()
    }
}

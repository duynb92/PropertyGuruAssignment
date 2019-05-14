//
//  ArticleDataSource.swift
//  PropertyGuruAssignment
//
//  Created by Duy Nguyen on 5/13/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit

protocol ArticleDataProviderType: UICollectionViewDataSource {
    func getArticles(query: String?, page: Int, completion: @escaping (APIResult<[Article]>) -> Void)
    
    func getArticlesCount() -> Int
    
    func getArticle(at indexPath: IndexPath) -> Article?
    
    func clearArticles()
}

class ArticleDataProvider: NSObject, ArticleDataProviderType {
    private var articleManager: ArticleManager!
    
    //MARK: - Constructors
    override init() {
        super.init()
        self.articleManager = ArticleManager.shared
    }
    
    init(_ articleManager: ArticleManager) {
        self.articleManager = articleManager
    }
    
    //MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.articleManager.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "ArticleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
        cell.setupCell(self.articleManager.articles[indexPath.row])
        return cell
    }
    
    //MARK: - Private Methods
    func getArticles(query: String?, page: Int, completion: @escaping (APIResult<[Article]>) -> Void) {
        self.articleManager.getArticles(query: query, page: page, completion: completion)
    }
    
    func getArticlesCount() -> Int {
        return self.articleManager.articles.count
    }
    
    func getArticle(at indexPath: IndexPath) -> Article? {
        return self.articleManager.getArticle(at: indexPath.row)
    }
    
    func clearArticles() {
        self.articleManager.clearArticles()
    }
}

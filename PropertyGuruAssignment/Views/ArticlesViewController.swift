//
//  ArticlesViewController.swift
//  PropertyGuruAssignment
//
//  Created by Duy Nguyen on 5/12/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController {
    @IBOutlet weak var colArticles: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingIndicator: CustomActivityIndicatorView!
    
    var articleManager: ArticleManager!
    var query: String? = nil
    var page: Int = 0
    let maximumItemsInPage = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colArticles.delegate = self
        colArticles.dataSource = self
        searchBar.delegate = self
        
        articleManager = ArticleManager.shared
        toogleLoadingIndicator()
        articleManager.getArticles(query: nil, page: page) { [weak self] (result) in
            self?.toogleLoadingIndicator()
            self?.getArticlesCompletion(result)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowArticleDetails" {
            if let destinationVC = segue.destination as? ArticleDetailsViewController, let selectedIndexPaths = self.colArticles.indexPathsForSelectedItems {
                destinationVC.article = self.articleManager.articles[selectedIndexPaths[0].row]
            }
        }
    }
    
    func toogleLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator.toogle()
        }
    }
    
    func getArticlesCompletion(_ result: APIResult<[Article]>) {
        switch result {
        case .success(let articles):
            let beforeAddedSize = self.articleManager.articles.count - articles.count
            DispatchQueue.main.async {
                self.colArticles.performBatchUpdates({
                    var indexPaths: [IndexPath] = []
                    for i in beforeAddedSize..<beforeAddedSize+articles.count {
                        indexPaths.append(IndexPath(row: i, section: 0))
                    }
                    self.colArticles.insertItems(at: indexPaths)
                }, completion: { (completed) in
                    print("BATCH UPDATE COMPLETED? \(completed)")
                })
            }
        case .failure(let error):
            print(error)
        }
    }
}


extension ArticlesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowArticleDetails", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.articleManager.articles.count - 2 {
            //Check if still have articles to get
            if (self.articleManager.articles.count < (self.page + 1) * maximumItemsInPage) {
                return
            }
            self.page = self.articleManager.articles.count / maximumItemsInPage
            toogleLoadingIndicator()
            articleManager.getArticles(query: self.query, page: self.page) { [weak self] (result) in
                self?.toogleLoadingIndicator()
                self?.getArticlesCompletion(result)
            }
        }
    }
}

extension ArticlesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}

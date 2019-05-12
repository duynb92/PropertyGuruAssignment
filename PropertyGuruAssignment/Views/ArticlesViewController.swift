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
    @IBOutlet weak var colSearchHistories: UICollectionView!
    
    //var searchHistoryManager: SearchHistoryManager!
    var query: String? = nil
    var page: Int = 0
    let maximumItemsInPage = 10
    var articleDataSource: ArticleDataSource!
    var searchHistoryDataSource: SearchHistoryDataSource!
    
    var isSearching: Bool = false {
        didSet {
            colArticles.isHidden = isSearching
            colSearchHistories.isHidden = !isSearching
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colArticles.delegate = self
        articleDataSource = ArticleDataSource()
        colArticles.dataSource = articleDataSource
        colSearchHistories.delegate = self
        searchHistoryDataSource = SearchHistoryDataSource()
        colSearchHistories.dataSource = searchHistoryDataSource
        searchBar.delegate = self
        
        toogleLoadingIndicator()
        articleDataSource.getArticles(query: nil, page: page) { [weak self] (result) in
            self?.toogleLoadingIndicator()
            self?.getArticlesCompletion(result)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowArticleDetails" {
            if let destinationVC = segue.destination as? ArticleDetailsViewController, let selectedIndexPaths = self.colArticles.indexPathsForSelectedItems {
                destinationVC.article = self.articleDataSource.getArticle(at: selectedIndexPaths[0])
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
            let beforeAddedSize = self.articleDataSource.getArticlesCount() - articles.count
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
    
    func doSearchArticle(_ query: String) {
        if (query.isEmpty || query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            self.query = nil
        } else {
            self.query = query
        }
        self.page = 0
        
        self.searchBar.text = self.query
        
        //Clear current articles
        articleDataSource.clearArticles()
        colArticles.reloadData()
        
        //Get articles with query
        toogleLoadingIndicator()
        articleDataSource.getArticles(query: self.query, page: self.page) { [weak self] (result) in
            self?.toogleLoadingIndicator()
            self?.getArticlesCompletion(result)
        }
    }
    
    func appendSearchHistory(_ searchString: String) {
        //Add search string to history
        searchHistoryDataSource.appendSearchHistory(searchString)
    }
    
    func stopSearching() {
        isSearching = false
        self.view.endEditing(true)
        colSearchHistories.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}


extension ArticlesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colArticles {
            self.performSegue(withIdentifier: "ShowArticleDetails", sender: nil)
        } else {
            stopSearching()
            let searchString = searchHistoryDataSource.getSearchHistory(at:indexPath.row)
            appendSearchHistory(searchString)
            doSearchArticle(searchString)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = collectionView == colArticles ? 200.0 : 50.0
        return CGSize(width: UIScreen.main.bounds.size.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == colArticles {
            if indexPath.row == self.articleDataSource.getArticlesCount() - 2 {
                //Check if still have articles to get
                if (self.articleDataSource.getArticlesCount() < (self.page + 1) * maximumItemsInPage) {
                    return
                }
                self.page = self.articleDataSource.getArticlesCount() / maximumItemsInPage
                toogleLoadingIndicator()
                articleDataSource.getArticles(query: self.query, page: self.page) { [weak self] (result) in
                    self?.toogleLoadingIndicator()
                    self?.getArticlesCompletion(result)
                }
            }
        }
    }
}

extension ArticlesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        stopSearching()
        if let searchString = searchBar.text {
            appendSearchHistory(searchString)
            doSearchArticle(searchString)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        stopSearching()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        stopSearching()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        isSearching = true
        self.colSearchHistories.reloadData()
        return true
    }
}

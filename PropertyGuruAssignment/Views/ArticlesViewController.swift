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
    @IBOutlet weak var lbNoArticles: UILabel!
    
    var query: String? = nil
    var page: Int = 0
    let maximumItemsInPage = 10
    var articleDataProvider: ArticleDataProviderType!
    var searchHistoryDataProvider: SearchHistoryDataProviderType!

    var isSearching: Bool = false {
        didSet {
            colArticles.isHidden = isSearching
            colSearchHistories.isHidden = !isSearching
        }
    }
    
    var isNotFoundArticles: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.colArticles.isHidden = self.isNotFoundArticles
                self.lbNoArticles.isHidden = !self.isNotFoundArticles
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleDataProvider = ArticleDataProvider()
        colArticles.dataSource = articleDataProvider
        colArticles.delegate = self
        
        searchHistoryDataProvider = SearchHistoryDataProvider()
        searchHistoryDataProvider.delegate = self
        colSearchHistories.dataSource = searchHistoryDataProvider
        colSearchHistories.delegate = searchHistoryDataProvider
        
        searchBar.delegate = self
        
        fetchArticles()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowArticleDetails" {
            if let destinationVC = segue.destination as? ArticleDetailsViewController, let selectedIndexPaths = self.colArticles.indexPathsForSelectedItems {
                destinationVC.article = self.articleDataProvider.getArticle(at: selectedIndexPaths[0])
            }
        }
    }
    
    func fetchArticles() {
        toogleLoadingIndicator()
        articleDataProvider.fetchArticles(query: query, page: page) { [weak self] (result) in
            self?.toogleLoadingIndicator()
            self?.getArticlesCompletion(result)
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
                isNotFoundArticles = self.articleDataProvider.getArticlesCount() == 0
                let beforeAddedSize = self.articleDataProvider.getArticlesCount() - articles.count
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
                isNotFoundArticles = true
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
        articleDataProvider.clearArticles()
        colArticles.reloadData()
        
        //Get articles with query
        fetchArticles()
    }
    
    func stopSearching() {
        isSearching = false
        self.view.endEditing(true)
        if (searchHistoryDataProvider.collectionView(colSearchHistories, numberOfItemsInSection: 0) > 0) {
            colSearchHistories.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func isLastPageOfArticles() -> Bool {
        return self.articleDataProvider.getArticlesCount() < (self.page + 1) * maximumItemsInPage
    }
}


extension ArticlesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 200.0
        return CGSize(width: UIScreen.main.bounds.size.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colArticles {
            self.performSegue(withIdentifier: "ShowArticleDetails", sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == colArticles {
            if indexPath.row == self.articleDataProvider.getArticlesCount() - 2 {
                //Check if still have articles to get
                if (isLastPageOfArticles()) {
                    return
                }
                self.page = self.articleDataProvider.getArticlesCount() / maximumItemsInPage
                fetchArticles()
            }
        }
    }
}

extension ArticlesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        stopSearching()
        if let searchString = searchBar.text {
            SearchHistoryManager.shared.appendSearchHistory(searchString)
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


extension ArticlesViewController : SearchHistoryDataProviderDelegate {
    func didSearchArticle(_ searchString: String) {
        stopSearching()
        doSearchArticle(searchString)
    }
}

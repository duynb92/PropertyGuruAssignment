//
//  SearchHistoryDataProvider.swift
//  PropertyGuruAssignment
//
//  Created by Duy Nguyen on 5/14/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit

protocol SearchHistoryDataProviderDelegate {
    func didSearchArticle(_ searchString: String)
}

class SearchHistoryDataProvider: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var delegate: SearchHistoryDataProviderDelegate?
    
    private var searchHistoryManager: SearchHistoryManager!
    
    //MARK: - Constructors
    override init() {
        self.searchHistoryManager = SearchHistoryManager.shared
        super.init()
    }
    
    init(_ searchHistoryManager: SearchHistoryManager) {
        self.searchHistoryManager = searchHistoryManager
        super.init()
    }
    
    //MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let searchString = getSearchHistory(at:indexPath.row)
        appendSearchHistory(searchString)
        if let delegate = delegate {
            delegate.didSearchArticle(searchString)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchHistoryManager.getSearchHistories().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "SearchHistoryCollectionViewCell", for: indexPath) as! SearchHistoryCollectionViewCell
        cell.setupCell(searchHistoryManager.getReversedSearchHistory()[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 50.0
        return CGSize(width: UIScreen.main.bounds.size.width, height: height)
    }
    
    //MARK: - Private Methods
    /// Append search string to history
    ///
    /// - Parameter searchString: search string to be appended
    private func appendSearchHistory(_ searchString: String) {
        return self.searchHistoryManager.appendSearchHistory(searchString)
    }
    
    
    /// Get search string at specific index
    ///
    /// - Parameter index: index of search string to get
    /// - Returns: search string if index is valid
    private func getSearchHistory(at index: Int) -> String {
        return searchHistoryManager.getReversedSearchHistory()[index]
    }
}

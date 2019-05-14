//
//  SearchHistoryDataProvider.swift
//  PropertyGuruAssignment
//
//  Created by Duy Nguyen on 5/14/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit

protocol SearchHistoryDataProviderType: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: SearchHistoryDataProviderDelegate? { get set }
    
    /// Append search string to history
    ///
    /// - Parameter searchString: search string to be appended
    func appendSearchHistory(_ searchString: String)
    
    /// Get search string at specific index
    ///
    /// - Parameter index: index of search string to get
    /// - Returns: search string if index is valid
    func getSearchHistory(at index: Int) -> String?
}

protocol SearchHistoryDataProviderDelegate {
    func didSearchArticle(_ searchString: String)
}

class SearchHistoryDataProvider: NSObject, SearchHistoryDataProviderType {
    
    var delegate: SearchHistoryDataProviderDelegate?
    
    internal var searchHistoryManager: SearchHistoryManagerType!
    
    //MARK: - Constructors
    override init() {
        super.init()
        self.searchHistoryManager = SearchHistoryManager.shared
    }
    
    init(_ searchHistoryManager: SearchHistoryManagerType) {
        self.searchHistoryManager = searchHistoryManager
        super.init()
    }
    
    //MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let searchString = getSearchHistory(at:indexPath.row) {
            appendSearchHistory(searchString)
            if let delegate = delegate {
                delegate.didSearchArticle(searchString)
            }
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
    internal func appendSearchHistory(_ searchString: String) {
        return self.searchHistoryManager.appendSearchHistory(searchString)
    }
    
    
    /// Get search string at specific index
    ///
    /// - Parameter index: index of search string to get
    /// - Returns: search string if index is valid
    internal func getSearchHistory(at index: Int) -> String? {
        if index >= 0 && index < searchHistoryManager.getReversedSearchHistory().count {
            return searchHistoryManager.getReversedSearchHistory()[index]
        } else {
            return nil
        }
    }
}

//
//  SearchHistoryDataSource.swift
//  PropertyGuruAssignment
//
//  Created by Duy Nguyen on 5/13/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit

class SearchHistoryDataSource: NSObject, UICollectionViewDataSource {
    private var searchHistoryManager: SearchHistoryManager!
    
    override init() {
        super.init()
        self.searchHistoryManager = SearchHistoryManager()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchHistoryManager.getSearchHistories().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "SearchHistoryCollectionViewCell", for: indexPath) as! SearchHistoryCollectionViewCell
        cell.setupCell(getReversedSearchHistory()[indexPath.row])
        return cell

    }
    
    
    /// Get search histories in reversed
    ///
    /// - Returns: list of search strings
    func getReversedSearchHistory() -> [String] {
        return self.searchHistoryManager.getSearchHistories().reversed()
    }
    
    
    /// Append search string to history
    ///
    /// - Parameter searchString: search string to be appended
    func appendSearchHistory(_ searchString: String) {
        return self.searchHistoryManager.appendSearchHistory(searchString)
    }
    
    
    /// Get search string at specific index
    ///
    /// - Parameter index: index of search string to get
    /// - Returns: search string if index is valid
    func getSearchHistory(at index: Int) -> String {
        return getReversedSearchHistory()[index]
    }
}

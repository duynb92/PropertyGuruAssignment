//
//  SearchHistoryManager.swift
//  PropertyGuruAssignment
//
//  Created by Duy Nguyen on 5/12/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import Foundation

class SearchHistoryManager {
    var searchHistoryKey = "SEARCH_HISTORY_KEY"
    let maximumSearchCount = 10
    private var searchHistories: [String] = []
    
    
    /// Append new search string to User Defaults
    ///
    /// - Parameter searchString: New search string to append
    func appendSearchHistory(_ searchString: String) {
        //Check if searchString is valid
        if (searchString.isEmpty) || (searchString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            return
        }
        
        //Get from UserDefaults
        if (searchHistories.count <= 0) {
            searchHistories = getSearchHistories()
        }
        //Remove first item if reach maximum count
        if (searchHistories.count >= maximumSearchCount) {
            searchHistories.remove(at: 0)
        }
        //Append new search string
        searchHistories.append(searchString)
        //Save to UserDefaults
        UserDefaults.standard.set(searchHistories, forKey: searchHistoryKey)
        UserDefaults.standard.synchronize()
    }
    
    
    /// Get search histories from User Defaults
    ///
    /// - Returns: List of search strings
    func getSearchHistories() -> [String] {
        if let searchHistories = UserDefaults.standard.value(forKey: searchHistoryKey) {
            self.searchHistories = searchHistories as! [String]
        }
        return self.searchHistories
    }
    
    
    /// Clear all search histories
    func clearSearchHistories() {
        UserDefaults.standard.set(nil, forKey: searchHistoryKey)
        UserDefaults.standard.synchronize()
    }
}

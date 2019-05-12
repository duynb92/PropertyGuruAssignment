//
//  SearchHistoryCollectionViewCell.swift
//  PropertyGuruAssignment
//
//  Created by Duy Nguyen on 5/12/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import UIKit

class SearchHistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lbHistory: UILabel!
    
    func setupCell(_ searchString: String) {
        lbHistory.text = searchString
    }
}

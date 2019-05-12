//
//  CustomActivityIndicatorView.swift
//  PropertyGuruAssignment
//
//  Created by Duy Nguyen on 5/12/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import UIKit

class CustomActivityIndicatorView: UIActivityIndicatorView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.layer.cornerRadius = 10.0
    }
    
    func toogle() {
        if self.isAnimating {
            self.stopAnimating()
        } else {
            self.startAnimating()
        }
    }
}

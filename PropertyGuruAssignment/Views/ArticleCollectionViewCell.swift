//
//  ArticleCollectionViewCell.swift
//  PropertyGuruAssignment
//
//  Created by Duy Nguyen on 5/12/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ivArticle: UIImageView!
    @IBOutlet weak var lbPubDate: UILabel!
    @IBOutlet weak var lbSnippet: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    
    func setupCell(_ article: Article) {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone.current
        lbPubDate.text = formatter.string(from: article.date)
        lbSnippet.text = article.snippet
        lbTitle.text = article.title
        
        DispatchQueue.global(qos: .background).async {
            if let imageUrl = URL(string: article.getImageUrl()), let data = try? Data(contentsOf: imageUrl) {
                DispatchQueue.main.async {
                    self.ivArticle.image = UIImage(data: data)
                }
            } else {
                DispatchQueue.main.async {
                    self.ivArticle.image = UIImage(named: "notfound")
                }
            }
        }
        
    }
}

//
//  ArticleDetailsViewController.swift
//  PropertyGuruAssignment
//
//  Created by Duy Nguyen on 5/12/19.
//  Copyright © 2019 Duy Nguyen. All rights reserved.
//

import UIKit
import WebKit

class ArticleDetailsViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadingIndicator: CustomActivityIndicatorView!
    
    var article: Article?
    var articleManager: ArticleManagerType!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        
        articleManager = ArticleManager.shared
    
        loadArticleDetails()
        
        //Add swipe gesture
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        leftSwipeGesture.direction = .left
        self.view.addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        rightSwipeGesture.direction = .right
        self.view.addGestureRecognizer(rightSwipeGesture)
    }
    
    
    /// Use webview to load article by its URL
    func loadArticleDetails() {
        if let article = article {
            let articleUrl = article.webUrl
            print("LOAD ARTICLE \(articleUrl)")
            let urlRequest = URLRequest(url: URL(string: articleUrl)!)
            webView.load(urlRequest)
        }
    }
    
    
    /// Handle swipe gesture
    ///
    /// - Parameter gestureRecognizer: Gesture that user has interacted with
    @objc func handleSwipeGesture(gestureRecognizer: UISwipeGestureRecognizer) {
        let articles = self.articleManager.getArticles()
        if let currentArticleIndex = articles.firstIndex(where: { $0.id == article?.id }) {
            let swipeLeftCondition = gestureRecognizer.direction == .left && currentArticleIndex < articles.count - 1
            let swipeRightCondition = gestureRecognizer.direction == .right && currentArticleIndex > 0
            if swipeLeftCondition {
                self.article = articles[currentArticleIndex+1]
            } else if swipeRightCondition {
                self.article = articles[currentArticleIndex-1]
            }
            if (swipeLeftCondition || swipeRightCondition) {
                loadArticleDetails()
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func toogleProgressView() {
        self.loadingIndicator.toogle()
    }
}

extension ArticleDetailsViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        toogleProgressView()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        toogleProgressView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        toogleProgressView()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        toogleProgressView()
    }
}

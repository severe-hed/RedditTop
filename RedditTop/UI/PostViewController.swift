//
//  PostViewController.swift
//  RedditTop
//
//  Created by Sergey Khliustin on 4/11/19.
//  Copyright © 2019 Sergey Khliustin. All rights reserved.
//

import UIKit
import WebKit

final class PostViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet private weak var webView: WKWebView!
    
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    var post: RedditPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        webView.navigationDelegate = self

        if let url = post?.url {
            self.openURL(url: url)
        }
    }

    private func openURL(url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    
}

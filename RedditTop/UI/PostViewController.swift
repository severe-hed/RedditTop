//
//  PostViewController.swift
//  RedditTop
//
//  Created by Sergey Khliustin on 4/11/19.
//  Copyright © 2019 Sergey Khliustin. All rights reserved.
//

import UIKit
import WebKit

final class PostViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    var post: RedditPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = post?.url {
            self.openURL(url: url)
        }
    }

    private func openURL(url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

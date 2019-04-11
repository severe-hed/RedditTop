//
//  WebViewController.swift
//  RedditTop
//
//  Created by Sergey Khliustin on 4/11/19.
//  Copyright © 2019 Sergey Khliustin. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = url {
            self.openURL(url: url)
        }
    }

    func openURL(url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

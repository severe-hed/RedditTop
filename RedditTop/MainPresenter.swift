//
//  MainPresenter.swift
//  RedditTop
//
//  Created by Sergey Khliustin on 4/11/19.
//  Copyright © 2019 Sergey Khliustin. All rights reserved.
//

import Foundation

class MainPresenter {
    private(set) var posts: [RedditPost] = []
    weak var controller: MainViewController?
    
    init(controller: MainViewController) {
        self.controller = controller
    }
    
    func reload() {
        RedditApiManager.shared.fetchTop(limit: 25, after: nil) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self.posts = posts
                    self.controller?.reloadData()
                case .failure(let error):
                    self.controller?.showError(error)
                }
            }
        }
    }
}

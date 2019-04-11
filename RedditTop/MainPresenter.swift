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
    private var isLoading: Bool = false
    
    init(controller: MainViewController) {
        self.controller = controller
    }
    
    func load() {
        if isLoading { return }
        isLoading = true
        
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
            self.isLoading = false
        }
    }
    
    func reload() {
        if isLoading { return }
        isLoading = true
        RedditApiManager.shared.fetchTop(limit: 25, after: nil, reloadCache: true) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self.posts = posts
                    self.controller?.reloadData()
                case .failure(let error):
                    self.controller?.showError(error)
                }
            }
            self.isLoading = false
        }
    }
    
    func loadMore() {
        guard let last = self.posts.last else {
            return
        }
        if isLoading { return }
        isLoading = true
        RedditApiManager.shared.fetchTop(limit: 25, after: last.name) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self.posts.append(contentsOf: posts)
                    self.controller?.loadedMore(count: posts.count)
                case .failure(let error):
                    self.controller?.showError(error)
                }
            }
            self.isLoading = false
        }
    }
}

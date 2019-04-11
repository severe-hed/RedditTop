//
//  ViewController.swift
//  RedditTop
//
//  Created by Sergey Khliustin on 4/11/19.
//  Copyright © 2019 Sergey Khliustin. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    var presenter: MainPresenter!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCells(PostCell.self)
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        refreshControl.beginRefreshing()
        
        self.presenter = MainPresenter(controller: self)
        presenter.reload()
    }
    
    @objc func refreshAction() {
        presenter.reload()
    }
    
    func reloadData() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func showError(_ error: NSError) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofClass: PostCell.self, indexPath: indexPath)
        cell.configure(post: presenter.posts[indexPath.row])
        return cell
    }
}


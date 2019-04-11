//
//  ViewController.swift
//  RedditTop
//
//  Created by Sergey Khliustin on 4/11/19.
//  Copyright © 2019 Sergey Khliustin. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching, PostCellDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var urlToOpen: URL?
    
    var presenter: MainPresenter!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCells(PostCell.self)
        tableView.addSubview(refreshControl)
        
        NotificationCenter.default.addObserver(self.tableView!,
                                               selector: #selector(UITableView.reloadData),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
        
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        refreshControl.beginRefreshing()
        
        self.presenter = MainPresenter(controller: self)
        presenter.load()
    }
    
    @objc func refreshAction() {
        presenter.reload()
    }
    
    func reloadData() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func loadedMore(count: Int) {
        tableView.reloadData()
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.last?.row == presenter.posts.count - 1 {
            presenter.loadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = presenter.posts[indexPath.row]
        self.urlToOpen = post.url
        self.performSegue(withIdentifier: "ShowWebView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWebView" {
            if let destination = segue.destination as? WebViewController {
                destination.url = self.urlToOpen
            }
        }
    }
    
    //MARK: - PostCellDelegate
    
    func postCellShareAction(_ sender: PostCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            if let url = presenter.posts[indexPath.row].shareURL {
                let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            }
            
        }
    }
}


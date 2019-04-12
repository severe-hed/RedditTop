//
//  ViewController.swift
//  RedditTop
//
//  Created by Sergey Khliustin on 4/11/19.
//  Copyright © 2019 Sergey Khliustin. All rights reserved.
//

import UIKit

protocol MainControllerProtocol: class {
    func reloadData()
    func appendData(count: Int)
    func showError(_ error: NSError)
}

final class MainViewController: UIViewController, MainControllerProtocol, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching, PostCellDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private var presenter: MainPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCells(PostCell.self)
        tableView.addSubview(refreshControl)
                
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        refreshControl.beginRefreshing()
        
        self.presenter = MainPresenter(controller: self)
        presenter.restoreState()
    }
    
    @objc private func refreshAction() {
        presenter.reload()
    }
    
    //MARK: - MainControllerProtocol
    
    func reloadData() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func appendData(count: Int) {
        tableView.reloadData()
    }
    
    func showError(_ error: NSError) {
        refreshControl.endRefreshing()
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWebView",
            let destination = segue.destination as? PostViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            
            let post = presenter.posts[indexPath.row]
            destination.post = post
            
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    //MARK: - UITableView
    
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let first = tableView.indexPathsForVisibleRows?.first {
            presenter.saveState(first.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowWebView", sender: nil)
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


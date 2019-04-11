//
//  PostCell.swift
//  RedditTop
//
//  Created by Sergey Khliustin on 4/11/19.
//  Copyright © 2019 Sergey Khliustin. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var mainTextLabel: UILabel!
    @IBOutlet private weak var subredditLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    
    func configure(post: RedditPost) {
        mainTextLabel.text = post.title
        subredditLabel.text = post.subreddit_name_prefixed
        infoLabel.text = "Posted by u/\(post.author) \(post.created_utc.hoursAgoSinceNow())"
        thumbnailImageView.loadFromURL(post.thumbnail)
    }
}

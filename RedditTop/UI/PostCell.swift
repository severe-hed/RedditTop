//
//  PostCell.swift
//  RedditTop
//
//  Created by Sergey Khliustin on 4/11/19.
//  Copyright © 2019 Sergey Khliustin. All rights reserved.
//

import UIKit

protocol PostCellDelegate: class {
    func postCellShareAction(_ sender: PostCell)
}

final class PostCell: UITableViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var mainTextLabel: UILabel!
    @IBOutlet private weak var subredditLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var commentsLabel: UILabel!
    @IBOutlet private weak var embeddedView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    
    weak var delegate: PostCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        embeddedView.layer.cornerRadius = 3
        embeddedView.layer.borderColor = UIColor.darkGray.cgColor
        embeddedView.layer.borderWidth = 1
    }
    
    func configure(post: RedditPost) {
        mainTextLabel.text = post.title
        subredditLabel.text = post.subreddit_name_prefixed
        infoLabel.text = "Posted by u/\(post.author) \(post.created_utc.hoursAgoSinceNow())"
        commentsLabel.text = "\(post.num_comments) Comments"
        
        if let thumbnail = post.thumbnail {
            thumbnailImageView.loadFromURL(thumbnail)
        }
        else {
            thumbnailImageView.isHidden = true
        }
    }
    @IBAction func shareAction(_ sender: Any) {
        self.delegate?.postCellShareAction(self)
    }
}

//
//  PostCell.swift
//  Photog
//
//  Created by THOMAS ENGLAND on 12/4/14.
//  Copyright (c) 2014 tomEngland. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    var post: PFObject? {

        didSet {
            self.configure()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.postImageView.image = UIImage(named: "PostPlaceholderImage")
        self.usernameLabel.text = nil
        self.dateLabel.text = nil

        self.post = nil
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.usernameLabel.text = nil
        self.dateLabel.text = nil
        self.contentView.backgroundColor = UIColor.OMLightGray()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure() {
        self.postImageView.clipsToBounds = true
        if let kPost = post {
            // set username label
            var user = kPost["user"] as PFUser
            user.fetchIfNeededInBackgroundWithBlock {
                (object, error) -> Void in
                if let kObject = object {
                    self.usernameLabel.text = user.username
                } else if let kError = error {
                    println("error pulling name")
                }
            }
            // set date label

            var date = kPost.createdAt.fuzzyTime()
            self.dateLabel.text = date


            //download image
            NetworkManager.sharedInstance.fetchImage(kPost) {
                (image, error) -> () in

                if image != nil {
                    self.postImageView.image = image
                } else {
                    //alert the user.
                }
            }
        }
    }
}

//
//  UserCell.swift
//  Photog
//
//  Created by THOMAS ENGLAND on 12/5/14.
//  Copyright (c) 2014 tomEngland. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var followButton: UIButton!
    var isFollowing: Bool?

    var user: PFUser? {
        didSet {
            self.configure()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.isFollowing = false
        self.followButton.hidden = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.followButton.hidden = true
        self.textLabel?.text = ""
        self.user = nil
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure() {

        if let kUser = user {
            self.textLabel?.text = kUser.username

            // are we following this person?, if so configure the button to unfollow. else configure to follow.
            NetworkManager.sharedInstance.isFollowing(kUser) {
                (isFollowing, error) -> () in

                if let kError = error {
                    //alert user or modify ui.
                } else {

                    self.isFollowing = isFollowing
                    if isFollowing == true {

                        //make viewLabel show unfollow
                        var imageUF = UIImage(named: "UnfollowButton")
                        self.followButton.setImage(imageUF, forState: .Normal)

                    } else {
                        //make viewLabel show follow
                        var imageF = UIImage(named: "FollowButton")
                        self.followButton.setImage(imageF, forState: .Normal)
                    }
                    self.followButton.hidden = false
                }
            }
        }
    }
    @IBAction func followUnfollowButtonPressed(sender: UIButton) {

        self.followButton.enabled = false
        var loading = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        loading.center = CGPointMake(followButton.bounds.size.width / 2, followButton.bounds.size.height / 2)
        loading.startAnimating()
        followButton.addSubview(loading)
        var following = !(self.isFollowing == true)

        NetworkManager.sharedInstance.updateFollowValue(following, user: self.user) { (error) -> () in
            var image = (following == true) ? UIImage(named: "UnfollowButton") : UIImage(named: "FollowButton")
            self.followButton.setImage(image, forState: .Normal)
            self.isFollowing = following
            self.followButton.enabled = true
            loading.stopAnimating()
            loading.removeFromSuperview()
        }
    }


}






















//
//  ProfileViewController.swift
//  Photog
//
//  Created by THOMAS ENGLAND on 12/7/14.
//  Copyright (c) 2014 tomEngland. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource {

    var items = []
    var user: PFUser?

    @IBOutlet weak var profileTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        var nib = UINib(nibName: "PostCell", bundle: nil)
        self.profileTableView.registerNib(nib, forCellReuseIdentifier: "PostCellIdentifier")
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NetworkManager.sharedInstance.fetchPosts(self.user, completionHandler: { (objects, error) -> () in

            if let kError = error {
                // alert user
            } else {
                self.items = objects!
                self.profileTableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


        return items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("PostCellIdentifier") as PostCell
        var item = items[indexPath.row] as PFObject

        cell.post = item
        
        return cell
    }
}

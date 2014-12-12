//
//  FeedViewController.swift
//  Photog
//
//  Created by THOMAS ENGLAND on 12/4/14.
//  Copyright (c) 2014 tomEngland. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource {

    var items = []
    @IBOutlet weak var tableView: UITableView!



    override func viewDidLoad() {
        super.viewDidLoad()

        var nib = UINib(nibName: "PostCell", bundle: nil)
        tableView?.registerNib(nib, forCellReuseIdentifier: "PostCellIdentifier")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NetworkManager.sharedInstance.fetchFeed {
            (objects, error) -> () in

            if let kObjects = objects {
                self.items = kObjects
                self.tableView?.reloadData()

            } else if let kError = error {
                //alert user
            }
            println(objects)
            println(error)
        }
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

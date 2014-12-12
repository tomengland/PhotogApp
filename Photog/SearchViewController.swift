//
//  SearchViewController.swift
//  Photog
//
//  Created by THOMAS ENGLAND on 12/4/14.
//  Copyright (c) 2014 tomEngland. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!

    var searchResults = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var nib = UINib(nibName: "UserCell", bundle: nil)
        self.searchTableView.registerNib(nib, forCellReuseIdentifier: "UserCellIdentifier")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
// Search Bar Delegate Funcitons
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.text = ""
        self.searchResults = []
        self.searchTableView.reloadData()
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {

        searchBar.resignFirstResponder()

        // NetworkManager searchUsers

        var searchTerm = searchBar.text

        NetworkManager.sharedInstance.findUsers(searchTerm) {
            (objects, error) -> () in

            if let kObjects = objects {
                self.searchResults = kObjects
                self.searchTableView.reloadData()
            } else if let kError = error {
                //alert user
            }
            
        }
    }

    // TableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCellIdentifier") as UserCell
        var user = self.searchResults[indexPath.row] as PFUser

        cell.user = user

        return cell
    }

    // TableView Delegate
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 57
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 57
    }
}

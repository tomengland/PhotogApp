//
//  NetworkManager.swift
//  Photog
//
//  Created by THOMAS ENGLAND on 12/3/14.
//  Copyright (c) 2014 tomEngland. All rights reserved.
//

import Foundation

typealias ObjectsCompletionHandler = (objects: [AnyObject]?, error: NSError?) -> ()
typealias BooleanCompletionHandler = (isFollowing: Bool?, error: NSError?) -> ()
typealias ImageCompletionHandler = (image: UIImage?, error: NSError?) -> ()
typealias ErrorCompletionHandler = (error: NSError?) -> ()


public class NetworkManager {
    public class var sharedInstance: NetworkManager {
        struct Singleton {
            static let instance = NetworkManager()
        }

        return Singleton.instance
    }

    func follow(user: PFUser!, completionHandler:(error: NSError?) -> ()) {

        var relation = PFUser.currentUser().relationForKey("following")
        relation.addObject(user)
        PFUser.currentUser().saveInBackgroundWithBlock {
            (success, error) -> Void in

            completionHandler(error: error)
            
        }
    }

    func fetchFeed(completionHandler: ObjectsCompletionHandler!) -> Void {

        var relation = PFUser.currentUser().relationForKey("following")
        var query = relation.query()

        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in

            if error != nil {
                println("error fetching following")
                completionHandler(objects: nil, error: error)
            } else {
                println("success fetching following: \(objects)")
                var postQuery = PFQuery(className: "Post")
                postQuery.whereKey("user", containedIn: objects)
                postQuery.orderByDescending("createdAt")
                postQuery.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]!, error: NSError!) -> Void in
                    if error != nil {
                        println("error fetching feed posts")
                        completionHandler(objects: nil, error: error)
                    } else {
                        println("success fetching feed posts \(objects)")
                        completionHandler(objects: objects, error: nil)
                    }
                }
            }
        }
    }

    func fetchImage(post: PFObject!, completionHandler: ImageCompletionHandler!) {

        var imageReference = post["image"] as PFFile

        imageReference.getDataInBackgroundWithBlock {
            (data, error) -> Void in

            if let kError = error {
                println("error fetching image \(kError.localizedDescription)")

                completionHandler(image:nil, error: kError)
            } else {
                let image = UIImage(data: data)
                completionHandler(image:image, error: nil)
            }
        }
    }

    func findUsers(searchTerm: String!, completionHandler: ObjectsCompletionHandler!) {
        var query = PFUser.query()
        
        query.whereKey("username", containsString: searchTerm)

        var descriptor = NSSortDescriptor(key: "username", ascending: false)
        query.orderBySortDescriptor(descriptor)

        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error != nil {
                println("error searching for users")
                completionHandler(objects: nil, error: error)
            } else {
                completionHandler(objects: objects, error: nil)
            }
        }
    }

    func isFollowing(user: PFUser!, completionHandler: BooleanCompletionHandler!) {
        var relation = PFUser.currentUser().relationForKey("following")
        var query = relation.query()

        query.whereKey("username", equalTo: user.username)
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in

            if error != nil {
                println("error determining if currentUser follows other User")
                completionHandler(isFollowing: false, error: error)
            } else {
                var isFollowing = objects.count > 0
                completionHandler(isFollowing: isFollowing, error: nil)
            }
        }
    }


    func updateFollowValue(value: Bool, user: PFUser!, completionHandler: ErrorCompletionHandler!) {
        var relation = PFUser.currentUser().relationForKey("following")

        if value == true {
            relation.addObject(user)

        } else {
            relation.removeObject(user)

        }

        PFUser.currentUser().saveInBackgroundWithBlock {
            (success, error) -> () in
            if error != nil {
                // error following user
            } else {
                completionHandler(error: error)
            }
        }
    }

    func fetchPosts(user: PFUser!, completionHandler: ObjectsCompletionHandler) {

        var postQuery = PFQuery(className: "Post")
        postQuery.whereKey("user", equalTo: user)
        postQuery.orderByDescending("createdAt")
        postQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                println("error fetching feed posts")
                completionHandler(objects: nil, error: error)
            } else {
                println("success fetching feed posts \(objects)")
                completionHandler(objects: objects, error: nil)
            }
        }
    }


    func postImage(image: UIImage, completionHandler: ErrorCompletionHandler?) {
        var imageData = UIImageJPEGRepresentation(image, 0.5) // returns NSData of JPG info with 0.5 compression factor.
        var pfFileName = PFUser.currentUser().username + " image.jpg"
        var imageFile = PFFile(name: pfFileName, data: imageData)

        var post = PFObject(className: "Post")
        post["image"] = imageFile
        post["user"] = PFUser.currentUser()
        post.saveInBackgroundWithBlock { (success, error) -> Void in

            if let kError = error {
                println(error)
            } else {
                if let kCompletionHandler = completionHandler {
                    kCompletionHandler(error: error)
                }
            }
        }
    }
}

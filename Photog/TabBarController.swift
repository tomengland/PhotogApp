//
//  TabBarController.swift
//  Photog
//
//  Created by THOMAS ENGLAND on 12/3/14.
//  Copyright (c) 2014 tomEngland. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

        var feedViewController = FeedViewController(nibName: "FeedViewController", bundle: nil)

        var profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileViewController.user = PFUser.currentUser()
        
        var searchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)

        var cameraViewController = UIViewController()
        var viewControllers = [feedViewController, profileViewController, searchViewController, cameraViewController]

        self.setViewControllers(viewControllers, animated: true)

        var imageNames = ["FeedIcon", "ProfileIcon", "SearchIcon", "CameraIcon"]

        let tabItems = tabBar.items as [UITabBarItem]
        for (index, value) in enumerate(tabItems)
        {
            var imageName = imageNames[index]
            value.image = UIImage(named: imageName)
            value.imageInsets = UIEdgeInsetsMake(5.0, 0, -5.0, 0)
        }

        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationItem.hidesBackButton = true
        self.tabBar.translucent = false


        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .Done, target: self, action: "didTapSignOut:")
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Photog"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didTapSignOut(sender: AnyObject) {
        PFUser.logOut()

        self.navigationController?.popToRootViewControllerAnimated(true)
        println("sign out")
    }

    // UITabBarControllerDelegate

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {

        var cameraViewController = self.viewControllers![3] as UIViewController
        if viewController == cameraViewController {
            showCamera()
            return false
        } else {
            return true
        }
    }
    func showCamera() {
        println("Show Camera")

        if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
            self.showAlert("No Camera", title: "Uh Oh!")
            return
        } else {
            var viewController = UIImagePickerController()
            viewController.sourceType = .Camera
            viewController.delegate = self
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerOriginalImage] as UIImage

        var resizedImage = image.resize(UIScreen.mainScreen().bounds.size.width * UIScreen.mainScreen().scale)

        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            // post the picture to parse.
            NetworkManager.sharedInstance.postImage(resizedImage, completionHandler: { (error) -> () in
                if let kError = error {
                    println("error")
                }
            })
        })
    }
}

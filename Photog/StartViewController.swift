//
//  StartViewController.swift
//  Photog
//
//  Created by THOMAS ENGLAND on 11/30/14.
//  Copyright (c) 2014 tomEngland. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInButtonPressed(sender: UIButton) {

        var viewController = AuthViewController(nibName: "AuthViewController", bundle: nil)
        viewController.authMode = .SignIn
        self.navigationController?.pushViewController(viewController, animated: true)

        println("signInButtonPressed")

    }
    @IBAction func signUpButtonPressed(sender: UIButton) {

        var viewController = AuthViewController(nibName: "AuthViewController", bundle: nil)
        viewController.authMode = .SignUp
        self.navigationController?.pushViewController(viewController, animated: true)
        
        println("signUpButtonPressed")
        
    }
}

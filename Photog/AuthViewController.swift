//
//  AuthViewController.swift
//  Photog
//
//  Created by THOMAS ENGLAND on 11/30/14.
//  Copyright (c) 2014 tomEngland. All rights reserved.
//

import UIKit

enum AuthMode {

  case SignIn
  case SignUp

}

class AuthViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  var authMode: AuthMode = AuthMode.SignUp
  


  override func viewDidLoad() {
    super.viewDidLoad()

    setupDelegates()

    var emailImageView = UIImageView(frame: CGRectMake(0, 0, 50, self.emailTextField.frame.size.height))
    emailImageView.image = UIImage(named: "EmailIcon")
    emailImageView.contentMode = .Center

    self.emailTextField.leftView = emailImageView
    self.emailTextField.leftViewMode = .Always

    var passwordImageView = UIImageView(frame: CGRectMake(0, 0, 50, self.passwordTextField.frame.size.height))
    passwordImageView.image = UIImage(named: "PasswordIcon")
    passwordImageView.contentMode = .Center

    self.passwordTextField.leftView = passwordImageView
    self.passwordTextField.leftViewMode = .Always

  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }

  override func viewDidAppear(animated: Bool) {

    self.emailTextField.becomeFirstResponder()

  }
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)

    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
// Helper Functions
  func textFieldShouldReturn(textField: UITextField) -> Bool {

    if textField == self.emailTextField {
      self.emailTextField.resignFirstResponder()
      self.passwordTextField.becomeFirstResponder()
    }
    else if textField == self.passwordTextField {
      self.passwordTextField.resignFirstResponder()
      self.authenticate()

    }
    return true
  }
  func authenticate() {

    var email = self.emailTextField.text.lowercaseString
    var password = self.passwordTextField.text


    if email.isEmpty == true || password.isEmpty == true || email.isEmailAddress() == false {
      //alert the user

      showAlert("Please use a valid E-Mail and/or Password")
      return
    }

    if authMode == .SignIn {
      self.signIn(email, password: password)
    } else {
      self.signUp(email, password: password)
    }

  }

  func setupDelegates() {
    emailTextField.delegate = self
    passwordTextField.delegate = self
  }

  func signIn(email: String, password: String) {

    PFUser.logInWithUsernameInBackground(email, password: password) {
      (user: PFUser!, error: NSError!) -> Void in
      if user != nil {

        var tabBarController = TabBarController()
        self.navigationController?.pushViewController(tabBarController, animated: true)
        println("sign in success!")
      } else {
        println("sign in failure! (alert the user)")
      }
    }
  }

  func signUp(email: String, password: String) {
    var user = PFUser()
    user.username = email
    user.email = email
    user.password = password

    user.signUpInBackgroundWithBlock {
      (succeeded: Bool!, error: NSError!) -> Void in

      if error == nil {
        println("Signup success!")

        // New User follows him/herself

        NetworkManager.sharedInstance.follow(user, completionHandler: {
            (error) -> () in

            if error == nil {
                var tabBarController = TabBarController()
                self.navigationController?.pushViewController(tabBarController, animated: true)
            } else {
                println("unable for user to follow himself")
            }
        })

      } else {
        println("Sign up failure! (Alert the User)")
      }
    }
  }

    
}

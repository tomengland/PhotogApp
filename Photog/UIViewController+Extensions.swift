//
//  UIViewController+Extensions.swift
//  Photog
//
//  Created by THOMAS ENGLAND on 12/2/14.
//  Copyright (c) 2014 tomEngland. All rights reserved.
//

import Foundation

extension UIViewController {

  func showAlert(message: String, title: String = "Uh Oh!") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
    self.presentViewController(alertController, animated: true, completion: nil)
  }
}
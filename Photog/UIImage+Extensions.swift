//
//  UIImage+Extensions.swift
//  Photog
//
//  Created by THOMAS ENGLAND on 12/7/14.
//  Copyright (c) 2014 tomEngland. All rights reserved.
//

import Foundation
extension UIImage {
    func resize(targetWidth: CGFloat) -> UIImage {
        var originalWidth = self.size.width
        if originalWidth <= targetWidth {
            return self
        } else {
            var scaleFactor = targetWidth / originalWidth
            var targetHeight = self.size.height * scaleFactor

            var newSize = CGSizeMake(targetWidth, targetHeight)
            UIGraphicsBeginImageContext(newSize)

            self.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))

            var newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage
        }
    }
}
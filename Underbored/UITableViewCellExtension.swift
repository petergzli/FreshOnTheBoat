//
//  UITableViewCellExtension.swift
//  Underbored
//
//  Created by Peter Guan Li on 10/10/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    /**
    Function renders an image view
    */
    
    func renderImageView(imageView: UIImageView, color: UIColor) {
        imageView.image = imageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imageView.tintColor = color
    }
    
    
    func renderButtonImageView(button: UIButton, imageName: String, color: UIColor) {
        let origImage = UIImage(named: imageName);
        let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        button.setImage(tintedImage, forState: .Normal)
        button.tintColor = color
    }
    
}
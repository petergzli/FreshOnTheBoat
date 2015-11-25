//
//  UIViewExtension.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/14/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func renderImageView(imageView: UIImageView, color: UIColor) {
        imageView.image = imageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imageView.tintColor = color
    }
    
    /**
    Function displays an alert message for an invalid preference selection when Pamper appears, and this is the wrong controller.
    */
    func displayAlertMessage(errorString: String, titleString: String) {
        let alertController = UIAlertController(title: titleString, message:
            errorString, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
    Function presents a view controller programatically form a different storyboard. If view controller is embedded in a navigation controller, an optional unwrapping is done to check for case
    
    - Parameter navigationControllerIdentifier: String identifier for the navigation controller, optional type.
    - Parameter viewControllerIdentifier: String identifier for a view controller not attached to a navigation controller.
    - Parameter storyboardIdentifier: String identifier for the storyboard
    */
    func presentViewControllerHelper(navigationControllerIdentifier: String?, viewControllerIdentifier: String?, storyboardIdentifier: String) {
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        var viewController: UIViewController!
        
        if let navigationControllerId = navigationControllerIdentifier {
            let navigationController = storyboard.instantiateViewControllerWithIdentifier(navigationControllerId) as! UINavigationController
            presentViewController(navigationController, animated: true, completion: nil)
        }
        if let viewControllerId = viewControllerIdentifier {
            viewController = storyboard.instantiateViewControllerWithIdentifier(viewControllerId)
            presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    /**
    Blurs the view using UIBlurEffect
    */
    func blurView(view: UIView) {
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffect = UIVisualEffectView(effect: darkBlur)
        blurEffect.frame = view.frame
        view.insertSubview(blurEffect, atIndex: 0)
    }
    
    func renderButtonImageView(button: UIButton, imageName: String, color: UIColor) {
        let origImage = UIImage(named: imageName);
        let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        button.setImage(tintedImage, forState: .Normal)
        button.tintColor = color
    }
    
    func addBackgroundImage(string: String) {
        let imageContainerView = UIImageView()
        let noDataLabel = UILabel()
        noDataLabel.textColor = UIColor.whiteColor()
        noDataLabel.textAlignment = .Center
        noDataLabel.numberOfLines = 3
        noDataLabel.backgroundColor = UIColor.clearColor()
        noDataLabel.text = string
        
        noDataLabel.font = UIFont.systemFontOfSize(17, weight: UIFontWeightLight)
        //noDataLabel.font = UIFont(name: "System", size: UIFontWeightLight)
        
        imageContainerView.image = UIImage(named: "desert2")!
        imageContainerView.contentMode = .ScaleAspectFill
        imageContainerView.tag = Globals.BackgroundImageTag
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.alpha = 0
        imageContainerView.addSubview(noDataLabel)
        let noDataLabelH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-24-[label]-24-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["label": noDataLabel])
        let noDataCenterY = NSLayoutConstraint.init(item: noDataLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: noDataLabel.superview, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        //let noDataLabelV = NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-64-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["label": noDataLabel])
        imageContainerView.addConstraints(noDataLabelH)
        imageContainerView.addConstraint(noDataCenterY)
        
        self.view.insertSubview(imageContainerView, atIndex: 1)
        let viewDictionary = ["background": imageContainerView]
        
        let viewConstraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[background]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary)
        let viewConstraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[background]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary)
        self.view.addConstraints(viewConstraintsH)
        self.view.addConstraints(viewConstraintsV)
        
        UIView.animateWithDuration(0.5, animations: {
            imageContainerView.alpha = 1
        })
    }
    
    func removeBackgroundImage() {
        if let imageContainerView = self.view.viewWithTag(Globals.BackgroundImageTag) {
            UIView.animateWithDuration(0.20, animations: {
                imageContainerView.alpha = 0
                }, completion: { finished in
                    imageContainerView.removeFromSuperview()
            })
        }
    }
    
    func initiateLoader(upperViewOptional: UIView? = nil, lowerViewOptional: UIView? = nil) {
        let customLoader = UIView()
        customLoader.backgroundColor = UIColor(red: 108 / 255.0, green: 189 / 255.0, blue: 232 / 255.0, alpha: 0.54)
        customLoader.translatesAutoresizingMaskIntoConstraints = false
        customLoader.tag = Globals.CustomLoaderTag
        
        var viewDictionary = ["customLoader": customLoader]
        self.view.addSubview(customLoader)
        
        let logo = UIImageView()
        customLoader.addSubview(logo)
        logo.contentMode = UIViewContentMode.ScaleAspectFit
        
        logo.image = UIImage(named: "logo-full")
        logo.image = logo.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        logo.tintColor = UIColor.whiteColor()
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        let logoConstraintX = NSLayoutConstraint.init(item: logo, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: logo.superview, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let logoConstraintY = NSLayoutConstraint.init(item: logo, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: logo.superview, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        
        customLoader.addConstraint(logoConstraintX)
        customLoader.addConstraint(logoConstraintY)
        
        let circleSurrounding = UIView(frame: CGRectMake(20, 20, 70, 70))
        customLoader.addSubview(circleSurrounding)
        circleSurrounding.translatesAutoresizingMaskIntoConstraints = false
        
        let circleSurroundingX = NSLayoutConstraint.init(item: circleSurrounding, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: circleSurrounding.superview, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let circleSurroundingY = NSLayoutConstraint.init(item: circleSurrounding, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: circleSurrounding.superview, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: circleSurrounding, attribute: .Width, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 70)
        let heightConstraint = NSLayoutConstraint(item: circleSurrounding, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 70)
        
        customLoader.addConstraint(widthConstraint)
        customLoader.addConstraint(heightConstraint)
        customLoader.addConstraint(circleSurroundingX)
        customLoader.addConstraint(circleSurroundingY)
        dashedBorderView(circleSurrounding)
        animateView(circleSurrounding)
        
        if let unwrappedUpperViewOptional = upperViewOptional {
            viewDictionary["upperView"] = unwrappedUpperViewOptional
            let loaderConstraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[customLoader]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary)
            let loaderConstraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:[upperView][customLoader]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary)
            self.view.addConstraints(loaderConstraintsH)
            self.view.addConstraints(loaderConstraintsV)
            return
        }
        
        if let unwrappedLowerViewOption = lowerViewOptional {
            viewDictionary["lowerView"] = unwrappedLowerViewOption
            let loaderConstraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[customLoader]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary)
            let loaderConstraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[customLoader][lowerView]", options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary)
            self.view.addConstraints(loaderConstraintsH)
            self.view.addConstraints(loaderConstraintsV)
            return
        }
        
        if let unwrappedUppwerViewOptional = upperViewOptional, let unwrappedLowerViewOption = lowerViewOptional {
            viewDictionary["lowerView"] = unwrappedLowerViewOption
            viewDictionary["upperView"] = unwrappedUppwerViewOptional
            let loaderConstraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[customLoader]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary)
            let loaderConstraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:[upperView][customLoader][lowerView]", options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary)
            self.view.addConstraints(loaderConstraintsH)
            self.view.addConstraints(loaderConstraintsV)
            return
        }
        
        let loaderConstraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[customLoader]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary)
        let loaderConstraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[customLoader]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary)
        self.view.addConstraints(loaderConstraintsH)
        self.view.addConstraints(loaderConstraintsV)
    }
    
    func dashedBorderView(view: UIView) {
        let border = CAShapeLayer()
        border.strokeColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).CGColor
        border.fillColor = nil
        border.lineDashPattern = [4, 4]
        border.lineWidth = 5
        border.path = UIBezierPath(roundedRect: view.bounds, cornerRadius:view.bounds.height/2).CGPath
        border.frame = view.bounds
        view.layer.addSublayer(border)
    }
    
    func animateView(view: UIView) {
        let duration = 2.0
        let delay = 0.0
        let fullRotation = CGFloat(M_PI * 2)
        UIView.animateKeyframesWithDuration(duration, delay: delay, options: [.CalculationModeLinear, .Repeat], animations: {
            // each keyframe needs to be added here
            // within each keyframe the relativeStartTime and relativeDuration need to be values between 0.0 and 1.0
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/3, animations: {
                // start at 0.00s (5s × 0)
                // duration 1.67s (5s × 1/3)
                // end at   1.67s (0.00s + 1.67s)
                view.transform = CGAffineTransformMakeRotation(1/3 * fullRotation)
            })
            UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 1/3, animations: {
                view.transform = CGAffineTransformMakeRotation(2/3 * fullRotation)
            })
            UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: {
                view.transform = CGAffineTransformMakeRotation(3/3 * fullRotation)
            })
            
            }, completion: {finished in
                // any code entered here will be applied
                // once the animation has completed
                
        })
    }
    
    func closeLoader() {
        if let customLoader = self.view.viewWithTag(Globals.CustomLoaderTag) {
            UIView.animateWithDuration(0.20, animations: {
                customLoader.alpha = 0
                }, completion: { finished in
                customLoader.removeFromSuperview()
            })
        }
    }


}
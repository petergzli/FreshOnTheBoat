//
//  ForumTitleTableViewCell.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/21/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit
import MapKit
import AlamofireImage

class ForumTitleTableViewCell: UITableViewCell {

    var forumPost: ForumPost!
    
    //MARK: Outlets
    @IBOutlet var flagIconImageView: UIImageView!
    @IBOutlet var forumDescriptionTextView: UITextView!
    @IBOutlet var forumCardView: UIView!
    @IBOutlet var heartIconImageView: UIImageView!
    @IBOutlet var forumNumberOfLikesCard: UILabel!
    @IBOutlet var forumTitleView: UITextView!
    @IBOutlet var forumUserCreatorButton: UIButton!
    @IBOutlet var forumCategoryImageIconImageView: UIImageView!
    @IBOutlet var forumCategoryView: UIView!
    @IBOutlet var locationPinButton: UIButton!
    
    @IBOutlet var attachedPhotoHeightConstraint: NSLayoutConstraint!
    @IBOutlet var attachedPhotoImageView: UIImageView!
    @IBOutlet var attachedPhotoToUsernameVerticalSpacingConstraint: NSLayoutConstraint!
    
    //MARK: Actions
    
    @IBAction func pinLocationButtonTapped(sender: UIButton) {
        guard let latitude = forumPost.locationPinned?.coordinate.latitude as Double?, longitude = forumPost.locationPinned?.coordinate.longitude as Double? else {
            
            return
        }
        
        let regionDistance:CLLocationDistance = 2500
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    
    
    //MARK: Helper functions
    
    /**
    Adds rounded corners to UIButton object.
    
    - Parameter button: UIButton
    */
    func addRoundedCornersToUIButton(button: UIButton) {
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 3
        button.layer.borderColor = Colors.redPurple.CGColor
    }
    
    
    /**
    Function sets up the forum post cell
    
    - Parameter forumCell: the particular forum cell to be configured
    - Returns: UITableViewCell
    */
    
    func setUpForumPostCell(forumPost: ForumPost) {
        self.forumPost = forumPost
        forumCardView.layer.cornerRadius = 8
        forumCategoryView.layer.cornerRadius = 5
        locationPinButton.layer.cornerRadius = 5
        forumTitleView.text = forumPost.title
        
        forumNumberOfLikesCard.text = String(forumPost.totalLikes)
        forumUserCreatorButton.setTitle(forumPost.createdBy!, forState: UIControlState.Normal)
        renderImageView(heartIconImageView, color: Colors.lightGrey)
        
        if let pinnedLocation = forumPost.locationPinned as CLLocation? {
            locationPinButton.backgroundColor = Colors.bluePurple
            renderButtonImageView(locationPinButton, imageName: "newforum-choose-location", color: Colors.green)
            print("open up maps app with pinnedLocation coordinates \(pinnedLocation)")
        } else {
            renderButtonImageView(locationPinButton, imageName: "newforum-choose-location", color: Colors.lightGrey)
        }
        
        if let description = forumPost.forumDescription {
            forumDescriptionTextView.text = description
        } else {
            forumDescriptionTextView.text = ""
        }
        
        if forumPost.userHasFlagged {
            flagIconImageView.hidden = false
            renderImageView(flagIconImageView, color: Colors.red)
        }
        
        if let unwrappedCategory = forumPost.category {
            setUpCategoryIconInViewAfterSelection(forumCategoryImageIconImageView, imageViewView: forumCategoryView, category: unwrappedCategory)
        }
        
        if forumPost.userHasLiked == 1{
            heartIconImageView.image = UIImage(named: "home-heartfilled")
            renderImageView(heartIconImageView, color: Colors.red)
            forumNumberOfLikesCard.textColor = Colors.red
        } else if forumPost.userHasLiked == -1 {
            heartIconImageView.image = UIImage(named: "home-heartfilled")
            renderImageView(heartIconImageView, color: Colors.mediumGrey)
            forumNumberOfLikesCard.textColor = Colors.mediumGrey
        } else {
            heartIconImageView.image = UIImage(named: "home-heartunfilled")
            renderImageView(heartIconImageView, color: Colors.redPurple)
            forumNumberOfLikesCard.textColor = Colors.redPurple
        }

        if forumPost.imageURL != nil && forumPost.imageURL != "" {
            attachedPhotoHeightConstraint.constant = 60
            attachedPhotoToUsernameVerticalSpacingConstraint.constant = 4
            attachedPhotoImageView.clipsToBounds = true
            attachedPhotoImageView.af_setImageWithURL(forumPost.imageNSURL()!, imageTransition: .CrossDissolve(0.2))
        } else {
            attachedPhotoHeightConstraint.constant = 0
            attachedPhotoToUsernameVerticalSpacingConstraint.constant = 0
        }
    }
       
    /**
    Set up category views
    
    - Parameter imageView: Image view containing the icon
    - Parameter imageViewView: View as the backgorund of the imageView
    - Parameter category: The category integer pertaining to the selected category
    */
    func setUpCategoryIconInViewAfterSelection(imageView: UIImageView, imageViewView: UIView, category: Int) {
        let selectedCategory = Category(rawValue: category)
        
        switch selectedCategory! {
        case .Food:
            imageView.image = UIImage(named: "category-food")
            imageViewView.backgroundColor = Colors.blue
        case .Shopping:
            imageView.image = UIImage(named: "category-shopping")
            imageViewView.backgroundColor = Colors.redPurple
        case .Entertainment:
            imageView.image = UIImage(named: "category-entertainment")
            imageViewView.backgroundColor = Colors.bluePurple
        case .General:
            imageView.image = UIImage(named: "category-general")
            imageViewView.backgroundColor = Colors.green
        }
    }
}
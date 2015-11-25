//
//  ForumCommentsTableViewCell.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/21/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit
import MapKit
import AlamofireImage

protocol ForumCommentsTableViewCellDelegate {
    func userHasLiked(forumCommentsTableViewCell: ForumCommentsTableViewCell)
}

class ForumCommentsTableViewCell: UITableViewCell {

    //MARK: Variables and constants
    var forumPostComment: ForumPostComment!
    var delegate: ForumCommentsTableViewCellDelegate?
    var likes: Int = 0
    var originalCenter = CGPoint()
    var userHasLikedDragRelease = false
    var userHasDislikedDragRelease = false
    
    //MARK: Outlets
    @IBOutlet var forumReplyTotalLabel: UILabel!
    @IBOutlet var forumReplyIconImageView: UIImageView!
    @IBOutlet var forumCommentsTextView: UITextView!
    
    @IBOutlet var forumNumberOfLikesLabel: UILabel!
    @IBOutlet var forumHeartIconImageView: UIImageView!
    @IBOutlet var usernameCreatedByButton: UIButton!
    
    @IBOutlet var pinnedLocationButton: UIButton!
    @IBOutlet var attachedPhotoImageView: UIImageView!
    
    @IBOutlet var forumHeartLikeContainerView: UIView!
    @IBOutlet var pinnedLocationButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet var attachedPhotoImageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var dislikeSwipeContainerViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var dislikeSwipeImageView: UIImageView!
    @IBOutlet var dislikeSwipeImageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var likeSwipeImageView: UIImageView!
    @IBOutlet var likeSwipeImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var likeSwipeContainerViewWidthConstraint: NSLayoutConstraint!
    
    //MARK: Actions
    @IBAction func pinnedLocationButtonTapped(sender: UIButton) {
        guard let latitude = forumPostComment.locationPinned?.coordinate.latitude as Double?, longitude = forumPostComment.locationPinned?.coordinate.longitude as Double? else {
            
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    //MARK: Gesture functions
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Began {
            originalCenter = center
        }
        
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            userHasLikedDragRelease = frame.origin.x > frame.size.width / 2.0
            userHasDislikedDragRelease = frame.origin.x < -frame.size.width / 2.0
            
            likeSwipeContainerViewWidthConstraint.constant = translation.x * 0.50
            likeSwipeImageViewWidthConstraint.constant = translation.x * 0.50
            
            dislikeSwipeContainerViewWidthConstraint.constant = -translation.x * 0.50
            dislikeSwipeImageViewWidthConstraint.constant = -translation.x * 0.50
        }
        
        if recognizer.state == .Ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
        
            if userHasLikedDragRelease && forumPostComment.userHasLiked != 1 {
                if forumPostComment.userHasLiked == -1 {
                    forumPostComment.totalLikes = forumPostComment.totalLikes + 2
                } else {
                    forumPostComment.totalLikes++
                }
                likes = 1
                forumPostComment.userHasLiked = likes
                delegate?.userHasLiked(self)
                
            }
            
            if userHasDislikedDragRelease && forumPostComment.userHasLiked != -1 {
                if forumPostComment.userHasLiked == 1 {
                    forumPostComment.totalLikes = forumPostComment.totalLikes - 2
                } else {
                    forumPostComment.totalLikes--
                }
                likes = -1
                forumPostComment.userHasLiked = likes
                delegate?.userHasLiked(self)
                
            }
            
            dislikeSwipeContainerViewWidthConstraint.constant = 0
            dislikeSwipeImageViewWidthConstraint.constant = 0
            likeSwipeImageViewWidthConstraint.constant = 0
            likeSwipeContainerViewWidthConstraint.constant = 0

            UIView.animateWithDuration(0.37, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 0, options: .CurveEaseInOut , animations: {
                self.frame = originalFrame
                }, completion: nil)
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    //MARK: Helper functions
    /**
    Creates the gradient for the background view.
    
    -Parameter UIView
    */
    func createGradient(didLike: Int = 0) {
        if didLike == 0 {
            forumHeartLikeContainerView.backgroundColor = UIColor(red: 245 / 255.0, green: 150 / 255.0, blue: 151 / 255.0, alpha: 0.25)
            
        } else if didLike == 1 {
            forumHeartLikeContainerView.backgroundColor = UIColor(red: 188 / 255.0, green: 132 / 255.0, blue: 186 / 255.0, alpha: 0.25)
            
        } else {
            forumHeartLikeContainerView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func animateLayer(didLike: Bool = true){
        var toColor: UIColor?
        if didLike {
            toColor = UIColor(red: 245 / 255.0, green: 150 / 255.0, blue: 151 / 255.0, alpha: 0.25)
        } else {
            toColor = Colors.lightGrey
        }
        
        UIView.animateWithDuration(2.0, animations: {
            self.forumHeartLikeContainerView.backgroundColor = toColor
        })
    }
    
    /**
    Custom heart animation function
    */
    func heartLikedSpringAnimation() {
        forumNumberOfLikesLabel.text = String(forumPostComment.totalLikes)
        print(forumNumberOfLikesLabel.text)
        forumHeartIconImageView.image = UIImage(named: "home-heartfilled")
        renderImageView(forumHeartIconImageView, color: Colors.red)
        forumHeartIconImageView.transform = CGAffineTransformMakeScale(2.0, 2.0)
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: [], animations: {
            self.forumHeartIconImageView.transform = CGAffineTransformIdentity
            self.forumNumberOfLikesLabel.textColor = Colors.red
            }, completion: nil)
    }
    
    func heartHasDislikedSpringAnimation() {
        forumNumberOfLikesLabel.text = String(forumPostComment.totalLikes)
        print(forumNumberOfLikesLabel.text)
        forumHeartIconImageView.image = UIImage(named: "home-heartfilled")
        renderImageView(forumHeartIconImageView, color: Colors.mediumGrey)
        forumHeartIconImageView.transform = CGAffineTransformMakeScale(2.0, 2.0)
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: [], animations: {
            self.forumHeartIconImageView.transform = CGAffineTransformIdentity
            self.forumNumberOfLikesLabel.textColor = Colors.mediumGrey
            }, completion: nil)
    }

    
    /**
    Sets up the forum comment cells with the appropriate body/username associated.
    
    - Parameter forumCommentCell: the respective forum comment cell.
    - Parameter indexPath: the index path of the comment cell
    
    - Returns: UITableViewCell
    */
    
    func setUpForumPostCommentCell(forumPostComment: ForumPostComment) {
        self.forumPostComment = forumPostComment
        
        likeSwipeContainerViewWidthConstraint.constant = 0
        likeSwipeImageViewWidthConstraint.constant = 0
        dislikeSwipeContainerViewWidthConstraint.constant = 0
        dislikeSwipeImageViewWidthConstraint.constant = 0
        renderImageView(dislikeSwipeImageView, color: Colors.mediumGrey)
        renderImageView(likeSwipeImageView, color: Colors.red)
        renderImageView(forumHeartIconImageView, color: Colors.redPurple)
        renderImageView(forumReplyIconImageView, color: Colors.white)
        forumCommentsTextView.text = forumPostComment.body
        usernameCreatedByButton.setTitle(forumPostComment.posterUsername, forState: UIControlState.Normal)
        attachedPhotoImageView.layer.cornerRadius = 5
        pinnedLocationButton.layer.cornerRadius = 5
        
        forumNumberOfLikesLabel.text = String(forumPostComment.totalLikes)
        if forumPostComment.locationPinned != nil {
            pinnedLocationButtonHeightConstraint.constant = 100
        } else {
            pinnedLocationButtonHeightConstraint.constant = 0
        }
        
        forumReplyTotalLabel.text = String(forumPostComment.totalReplies)
        
        if let forumPostImageURL = forumPostComment.imageURL where forumPostImageURL != "" {
            attachedPhotoImageView.clipsToBounds = true
            if forumPostComment.attachedPhoto != nil {
                attachedPhotoImageView.image = forumPostComment.attachedPhoto!
            } else {
                attachedPhotoImageView.af_setImageWithURL(forumPostComment.imageNSURL()!, imageTransition: .CrossDissolve(0.2))
            }
            attachedPhotoImageViewHeightConstraint.constant = 100
        } else {
            attachedPhotoImageViewHeightConstraint.constant = 0
        }

        renderButtonImageView(pinnedLocationButton, imageName: "newforum-choose-location", color: Colors.green)
        
        if forumPostComment.userHasLiked == 1 {
            forumHeartIconImageView.image = UIImage(named: "home-heartfilled")
            renderImageView(forumHeartIconImageView, color: Colors.red)
            forumNumberOfLikesLabel.textColor = Colors.red
            
        } else if forumPostComment.userHasLiked == -1 {
            forumHeartIconImageView.image = UIImage(named: "home-heartfilled")
            renderImageView(forumHeartIconImageView, color: Colors.mediumGrey)
            forumNumberOfLikesLabel.textColor = Colors.mediumGrey
            
        } else {
            forumHeartIconImageView.image = UIImage(named: "home-heartunfilled")
            renderImageView(forumHeartIconImageView, color: Colors.redPurple)
            forumNumberOfLikesLabel.textColor = Colors.redPurple
            
        }
    }
}

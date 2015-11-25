//
//  ForumRepliesReplyTableViewCell.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/24/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit
import MapKit
import AlamofireImage

protocol ForumRepliesReplyTableViewCellDelegate {
    func userHasLiked(forumRepliesReplyTableViewCell: ForumRepliesReplyTableViewCell)
}

class ForumRepliesReplyTableViewCell: UITableViewCell {
    
    //MARK: Variables and constants
    var forumPostCommentReply: ForumPostComment!
    var delegate: ForumRepliesReplyTableViewCellDelegate?
    var originalCenter = CGPoint()
    var likes:Int = 0
    var userHasLikedDragRelease = false
    var userHasDislikedDragRelease = false

    //MARK: Outlets
    @IBOutlet var forumRepliesTextView: UITextView!
    @IBOutlet var forumRepliesNumberLabel: UILabel!
    @IBOutlet var forumRepliesReplyIconImageView: UIImageView!
    
    @IBOutlet var forumLikesContainerView: UIView!
    @IBOutlet var forumRepliesHeartIconImageView: UIImageView!
    @IBOutlet var forumRepliesUsernameLabel: UILabel!
    @IBOutlet var forumRepliesNumberOfLikesLabel: UILabel!
    @IBOutlet var pinnedLocationButton: UIButton!
    @IBOutlet var attachedPhotoImageView: UIImageView!
    
    @IBOutlet var pinnedLocationButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet var attachedPhotoImageViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet var likeSwipeImageView: UIImageView!
    @IBOutlet var likeSwipeContainerViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var likeSwipeImageViewWidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet var dislikeSwipeImageView: UIImageView!
    @IBOutlet var dislikeSwipeImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var dislikeSwipeContainerViewWidthConstraint: NSLayoutConstraint!
    
    
    
    //MARK: Init functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    //MARK: Actions
    @IBAction func pinLocationButtonTapped(sender: UIButton) {
        guard let latitude = forumPostCommentReply.locationPinned?.coordinate.latitude as Double?, longitude = forumPostCommentReply.locationPinned?.coordinate.longitude as Double? else {
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
            
            if userHasLikedDragRelease && forumPostCommentReply.userHasLiked != 1 {
                if forumPostCommentReply.userHasLiked == -1 {
                    forumPostCommentReply.totalLikes = forumPostCommentReply.totalLikes + 2
                } else {
                    forumPostCommentReply.totalLikes++
                }
                likes = 1
                forumPostCommentReply.userHasLiked = likes
                delegate?.userHasLiked(self)
                
            }
            if userHasDislikedDragRelease && forumPostCommentReply.userHasLiked != -1 {
                if forumPostCommentReply.userHasLiked == 1 {
                    forumPostCommentReply.totalLikes = forumPostCommentReply.totalLikes - 2
                } else {
                    forumPostCommentReply.totalLikes--
                }
                likes = -1
                forumPostCommentReply.userHasLiked = likes
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
            forumLikesContainerView.backgroundColor = UIColor(red: 245 / 255.0, green: 150 / 255.0, blue: 151 / 255.0, alpha: 0.25)
            
        } else if didLike == 1 {
            forumLikesContainerView.backgroundColor = UIColor(red: 188 / 255.0, green: 132 / 255.0, blue: 186 / 255.0, alpha: 0.25)
            
        } else {
            forumLikesContainerView.backgroundColor = UIColor.whiteColor()
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
            self.forumLikesContainerView.backgroundColor = toColor
        })
    }
    
    /**
    Function executes custom like heart animation function
    */
    func heartLikedSpringAnimation() {
        forumRepliesHeartIconImageView.image = UIImage(named: "home-heartfilled")
        forumRepliesNumberOfLikesLabel.text = String(forumPostCommentReply.totalLikes)
        renderImageView(forumRepliesHeartIconImageView, color: Colors.red)
        forumRepliesHeartIconImageView.transform = CGAffineTransformMakeScale(2.0, 2.0)
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: [], animations: {
            self.forumRepliesHeartIconImageView.transform = CGAffineTransformIdentity
            self.forumRepliesNumberOfLikesLabel.textColor = Colors.red
            }, completion: nil)
    }
    
    func heartHasDislikedSpringAnimation() {
        forumRepliesHeartIconImageView.image = UIImage(named: "home-heartfilled")
        forumRepliesNumberOfLikesLabel.text = String(forumPostCommentReply.totalLikes)
        renderImageView(forumRepliesHeartIconImageView, color: Colors.mediumGrey)
        forumRepliesHeartIconImageView.transform = CGAffineTransformMakeScale(2.0, 2.0)
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: [], animations: {
            self.forumRepliesHeartIconImageView.transform = CGAffineTransformIdentity
            self.forumRepliesNumberOfLikesLabel.textColor = Colors.mediumGrey
            }, completion: nil)
    }

    /**
    Sets up the forum comment cells with the appropriate body/username associated.
    
    - Parameter forumCommentCell: the respective forum comment cell.
    - Parameter indexPath: the index path of the comment cell
    
    - Returns: UITableViewCell
    */
    
    func setUpForumCommentReplyCell(forumPostCommentReply: ForumPostComment) {
        self.forumPostCommentReply = forumPostCommentReply
        likeSwipeContainerViewWidthConstraint.constant = 0
        likeSwipeImageViewWidthConstraint.constant = 0
        dislikeSwipeContainerViewWidthConstraint.constant = 0
        dislikeSwipeImageViewWidthConstraint.constant = 0
        renderImageView(dislikeSwipeImageView, color: Colors.mediumGrey)
        renderImageView(likeSwipeImageView, color: Colors.red)

        
        forumRepliesTextView.text = forumPostCommentReply.body
        forumRepliesUsernameLabel.text = forumPostCommentReply.posterUsername
        renderImageView(forumRepliesReplyIconImageView, color: Colors.white)
        renderImageView(forumRepliesHeartIconImageView, color: Colors.redPurple)
        attachedPhotoImageView.layer.cornerRadius = 5
        pinnedLocationButton.layer.cornerRadius = 5
        
        if forumPostCommentReply.locationPinned != nil {
            pinnedLocationButtonHeightConstraint.constant = 100
        } else {
            pinnedLocationButtonHeightConstraint.constant = 0
        }
        if let forumPostImageURL = forumPostCommentReply.imageURL where forumPostImageURL != "" {
            attachedPhotoImageView.clipsToBounds = true
            
            if forumPostCommentReply.attachedPhoto != nil {
                attachedPhotoImageView.image = forumPostCommentReply.attachedPhoto!
            } else {
                attachedPhotoImageView.af_setImageWithURL(forumPostCommentReply.imageNSURL()!, imageTransition: .CrossDissolve(0.2))
            }
            attachedPhotoImageViewHeightConstraint.constant = 100
        } else {
            attachedPhotoImageViewHeightConstraint.constant = 0
        }
        
        renderButtonImageView(pinnedLocationButton, imageName: "newforum-choose-location", color: Colors.green)
        forumRepliesNumberLabel.text = String(forumPostCommentReply.totalReplies)
        forumRepliesNumberOfLikesLabel.text = String(forumPostCommentReply.totalLikes)
        if forumPostCommentReply.userHasLiked == 1 {
            forumRepliesHeartIconImageView.image = UIImage(named: "home-heartfilled")
            renderImageView(forumRepliesHeartIconImageView, color: Colors.red)
            forumRepliesNumberOfLikesLabel.textColor = Colors.red
            
        } else if forumPostCommentReply.userHasLiked == -1 {
            forumRepliesHeartIconImageView.image = UIImage(named: "home-heartfilled")
            renderImageView(forumRepliesHeartIconImageView, color: Colors.mediumGrey)
            forumRepliesNumberOfLikesLabel.textColor = Colors.mediumGrey
            
        }else {
            forumRepliesHeartIconImageView.image = UIImage(named: "home-heartunfilled")
            renderImageView(forumRepliesHeartIconImageView, color: Colors.redPurple)
            forumRepliesNumberOfLikesLabel.textColor = Colors.redPurple
            
        }
    }
}

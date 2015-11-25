//
//  HomeForumTableViewCell.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/14/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit

protocol HomeForumTableViewCellDelegate {
    func userHasLiked(homeForumtableViewCell: HomeForumTableViewCell)
}

class HomeForumTableViewCell: UITableViewCell {

    //MARK: Variables and constants
    var forumPost: ForumPost!
    var delegate: HomeForumTableViewCellDelegate?
    var originalCenter = CGPoint()
    var gradient: CAGradientLayer = CAGradientLayer()
    var userHasLikedDragRelease = false
    var userHasDislikedDragRelease = false
    var likes: Int = 0
    
    //MARK: Outlets
    @IBOutlet var forumTitleTextView: UITextView!
    @IBOutlet var forumReplyIconImage: UIImageView!
    @IBOutlet var forumReplyTotalNumberLabel: UILabel!
    @IBOutlet var forumLikeHeartIconImage: UIImageView!
    @IBOutlet var forumLikeTotalNumberLabel: UILabel!
    @IBOutlet var tableViewCellContainerView: UIView!

    @IBOutlet var forumLikesContainerView: UIView!
    @IBOutlet var tableViewHeartSwipeContainerView: NSLayoutConstraint!
    
    @IBOutlet var talbeViewCellDislikeSwipeImageView: UIImageView!
    @IBOutlet var tableViewCellDislikeSwipeContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var tableViewCellDislikeImageViewSwipeConstraint: NSLayoutConstraint!
    @IBOutlet var talbeViewCellHeartSwipeImageView: UIImageView!
    @IBOutlet var tableViewCellHeartSwipeImageViewWidthConstraint: NSLayoutConstraint!
    
    //MARK: Init functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        tableViewCellContainerView.addGestureRecognizer(recognizer)
    }
    
    //MARK: Gesture functions

    func handlePan(recognizer: UIPanGestureRecognizer) {
        
        if recognizer.state == .Began {
            originalCenter = center
        }

        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(tableViewCellContainerView)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            tableViewCellHeartSwipeImageViewWidthConstraint.constant = translation.x * 0.50
            tableViewHeartSwipeContainerView.constant = translation.x * 0.50
            
            tableViewCellDislikeSwipeContainerViewWidthConstraint.constant = -translation.x * 0.50
            tableViewCellDislikeImageViewSwipeConstraint.constant = -translation.x * 0.50
            
            
            userHasLikedDragRelease = frame.origin.x > frame.size.width / 2.0
            userHasDislikedDragRelease = frame.origin.x < -frame.size.width / 2.0
        }

        if recognizer.state == .Ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            
            if userHasLikedDragRelease && forumPost.userHasLiked != 1 {
                if forumPost.userHasLiked == -1 {
                    forumPost.totalLikes = forumPost.totalLikes + 2
                } else {
                    forumPost.totalLikes++
                }
                likes = 1
                forumPost.userHasLiked = likes
                delegate?.userHasLiked(self)
                
            }
            if userHasDislikedDragRelease && forumPost.userHasLiked != -1 {
                if forumPost.userHasLiked == 1 {
                    forumPost.totalLikes = forumPost.totalLikes - 2
                } else {
                    forumPost.totalLikes--
                }
                likes = -1
                forumPost.userHasLiked = likes
                delegate?.userHasLiked(self)
                
            }
            
            tableViewCellDislikeSwipeContainerViewWidthConstraint.constant = 0
            tableViewCellDislikeImageViewSwipeConstraint.constant = 0
            tableViewCellHeartSwipeImageViewWidthConstraint.constant = 0
            tableViewHeartSwipeContainerView.constant = 0
            UIView.animateWithDuration(0.37, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 0, options: .CurveEaseInOut , animations: {
                self.frame = originalFrame
                self.layoutIfNeeded()
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
    Function to perform the heart animation when pan gesture has pulled cell far enough
    */
    
    func heartLikedSpringAnimation() {
        forumLikeTotalNumberLabel.text = String(forumPost.totalLikes)
        forumLikeTotalNumberLabel.textColor = Colors.red 
        forumLikeHeartIconImage.image = UIImage(named: "home-heartfilled")
        renderImageView(forumLikeHeartIconImage, color: Colors.red)
        forumLikeHeartIconImage.transform = CGAffineTransformMakeScale(2.0, 2.0)
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: [], animations: {
            self.forumLikeHeartIconImage.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func heartDislikedSpringAnimation() {
        forumLikeTotalNumberLabel.text = String(forumPost.totalLikes)
        forumLikeTotalNumberLabel.textColor = Colors.mediumGrey
        forumLikeHeartIconImage.image = UIImage(named: "home-heartfilled")
        renderImageView(forumLikeHeartIconImage, color: Colors.mediumGrey)
        forumLikeHeartIconImage.transform = CGAffineTransformMakeScale(2.0, 2.0)
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: [], animations: {
            self.forumLikeHeartIconImage.transform = CGAffineTransformIdentity
            }, completion: nil)
    }

    /**
    Function sets up the labels from the forumPost that is passed into the cell

    - Parameter forumPost: the forum post that is passed from the root view controller
    */
    func setCell(forumPost: ForumPost) {
        tableViewCellHeartSwipeImageViewWidthConstraint.constant = 0
        tableViewHeartSwipeContainerView.constant = 0
        tableViewCellDislikeSwipeContainerViewWidthConstraint.constant = 0
        tableViewCellDislikeImageViewSwipeConstraint.constant = 0
        
        self.forumPost = forumPost
        renderImageView(talbeViewCellDislikeSwipeImageView, color: Colors.mediumGrey)
        renderImageView(talbeViewCellHeartSwipeImageView, color: Colors.red)
        renderImageView(forumReplyIconImage, color: UIColor.whiteColor())
        forumTitleTextView.text = forumPost.title
        selectionStyle = UITableViewCellSelectionStyle.None
        forumLikeTotalNumberLabel.text = String(forumPost.totalLikes)
        forumReplyTotalNumberLabel.text = String(forumPost.totalComments)
        
        if forumPost.userHasLiked == 1 {
            forumLikeHeartIconImage.image = UIImage(named: "home-heartfilled")
            renderImageView(forumLikeHeartIconImage, color: Colors.red)
            forumLikeTotalNumberLabel.textColor = Colors.red
            
        } else if forumPost.userHasLiked == -1 {
            forumLikeHeartIconImage.image = UIImage(named: "home-heartfilled")
            renderImageView(forumLikeHeartIconImage, color: Colors.mediumGrey)
            forumLikeTotalNumberLabel.textColor = Colors.mediumGrey
            
        } else {
            forumLikeHeartIconImage.image = UIImage(named: "home-heartunfilled")
            renderImageView(forumLikeHeartIconImage, color: Colors.redPurple)
            forumLikeTotalNumberLabel.textColor = Colors.redPurple
            
        }
    }
}

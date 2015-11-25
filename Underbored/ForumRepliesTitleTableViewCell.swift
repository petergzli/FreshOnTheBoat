//
//  ForumRepliesTitleTableViewCell.swift
//  Underbored
//
//  Created by Peter Guan Li on 9/24/15.
//  Copyright © 2015 Underbored. All rights reserved.
//

import UIKit

class ForumRepliesTitleTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet var commentTitleBodyTextView: UITextView!
    @IBOutlet var commentTitleHeartIconImageView: UIImageView!
    @IBOutlet var commentTitleNumberOfLikesLabel: UILabel!
    @IBOutlet var commentTitleUserNameButton: UIButton!
    @IBOutlet var commentTitleCardView: UIView!
    
    //MARK: Helper functions
    
    /**
    Function sets up the forum post cell
    
    - Parameter forumCell: the particular forum cell to be configured
    - Returns: UITableViewCell
    */
    
    func setUpCommentTitleCell(forumCommentReply: ForumPostComment) {
        commentTitleCardView.layer.cornerRadius = 5
        commentTitleBodyTextView.text = forumCommentReply.body
        commentTitleUserNameButton.setTitle(forumCommentReply.posterUsername, forState: UIControlState.Normal)
        renderImageView(commentTitleHeartIconImageView, color: Colors.lightGrey)
        
        commentTitleNumberOfLikesLabel.text = String(forumCommentReply.totalLikes)
        
        if forumCommentReply.userHasLiked == 1 {
            commentTitleHeartIconImageView.image = UIImage(named: "home-heartfilled")
            renderImageView(commentTitleHeartIconImageView, color: Colors.red)
            commentTitleNumberOfLikesLabel.textColor = Colors.red
        } else if forumCommentReply.userHasLiked == -1 {
            commentTitleHeartIconImageView.image = UIImage(named: "home-heartfilled")
            renderImageView(commentTitleHeartIconImageView, color: Colors.mediumGrey)
            commentTitleNumberOfLikesLabel.textColor = Colors.mediumGrey
        } else {
            commentTitleHeartIconImageView.image = UIImage(named: "home-heartunfilled")
            renderImageView(commentTitleHeartIconImageView, color: Colors.redPurple)
            commentTitleNumberOfLikesLabel.textColor = Colors.redPurple
        }
    }
}
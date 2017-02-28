//
//  CommentCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 26..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    var comment: Comment? {
        didSet {
            if let comment = self.comment {
                if let commentParent = comment.parent, commentParent != comment.key {
                    userImageViewLeftConstraint?.constant = Constants.userProfileImageSize.lessSmall + 16
                    dividerView.isHidden = true
                } else {
                    userImageViewLeftConstraint?.constant = 8
                    dividerView.isHidden = false
                }
                formDate(timestamp: comment.timestamp.doubleValue)
                commentTextView.text = comment.text
                observeFirebaseValue(userId: comment.userId)
            }
        }
    }

    func formDate(timestamp: Double) {
        let timestampDate = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        dateTimeLabel.text = dateFormatter.string(from: timestampDate)
    }
    
    func observeFirebaseValue(userId: String) {
        FirebaseDataService.instance.userRef.child(userId).child(Constants.Users.imageUrl).observeSingleEvent(of: .value, with: { (snapshot) in
            if let imageUrl = snapshot.value as? String {
                self.userImageView.imageUrlString = imageUrl
            }
        })
        FirebaseDataService.instance.userRef.child(userId).child(Constants.Users.username).observeSingleEvent(of: .value, with: { (snapshot) in
            if let username = snapshot.value as? String {
                self.usernameLabel.text = username
            }
        })
    }
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let userImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let commentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageView?.layer.cornerRadius = 8
        
        addSubViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addSubViews() {
        contentView.addSubview(dividerView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(dateTimeLabel)
        contentView.addSubview(userImageView)
        contentView.addSubview(commentTextView)
    }
    
    var commentBottomConstraint: NSLayoutConstraint?
    var userImageViewLeftConstraint: NSLayoutConstraint?
    
    fileprivate func setConstraints() {
        _ = dividerView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        userImageViewLeftConstraint = userImageView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: Constants.userProfileImageSize.lessSmall, heightConstant: Constants.userProfileImageSize.lessSmall)[1]
        
        _ = usernameLabel.anchor(contentView.topAnchor, left: userImageView.rightAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 16)
        
        _ = dateTimeLabel.anchor(usernameLabel.bottomAnchor, left: userImageView.rightAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 14)
        
        commentBottomConstraint = commentTextView.anchor(dateTimeLabel.bottomAnchor, left: userImageView.rightAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 2, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)[2]
    }
}

//
//  UserInfoCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class UserInfoCell: BaseCell {

    var myUid: String?
    var userInfo: Users? {
        didSet {
            if let user = self.userInfo {
                self.userBackgroundImageView.imageUrlString = user.backgroundImageUrl
                self.userProfileImageView.imageUrlString = user.imageUrl
                self.titleLabel.text = user.username
                self.introTextView.text = user.intro
                self.setPersonalStatistics(numComments: user.numComments, numFollowers: user.numFollowers, numFollowings: user.numFollowings)
                
                if let myUid = self.myUid {
                    if user.uid == myUid {
                        followButton.isHidden = true
                    }
                }
                checkFollowButtonState()
            }
        }
    }
    
    func setPersonalStatistics(numComments: Int, numFollowers: Int, numFollowings: Int) {
        commentsNumTextView.attributedText = putDashBoardAttributedText(number: numComments, type: "댓글")
        followersNumTextView.attributedText = putDashBoardAttributedText(number: numFollowers, type: "팔로워")
        followingNumTextView.attributedText = putDashBoardAttributedText(number: numFollowings, type: "팔로잉")
    }
    
    func putDashBoardAttributedText(number: Int, type: String) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(number)", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium),
            NSForegroundColorAttributeName: UIColor.black
            ])
        
        attributedText.append(NSAttributedString(string: "\n\(type)", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.darkGray
            ]))
        
        // center alignment
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.string.characters.count))
        return attributedText
    }
    
    let userBackgroundImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userProfileImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder2")
        imageView.layer.cornerRadius = Constants.userProfileImageSize.extra / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 0.6
        return imageView
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "icon small plus")
        image?.resizableImage(withCapInsets: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230).cgColor
        button.layer.borderWidth = 0.4
        button.layer.cornerRadius = button.frame.width / 2
        button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon small comment"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230).cgColor
        button.layer.borderWidth = 0.4
        button.layer.cornerRadius = button.frame.width / 2
        return button
    }()
    
    func followButtonTapped(sender: UIButton) {
        changeFollowButtonState()
    }
    
    func checkFollowButtonState() {
        if let shownUid = self.userInfo?.uid, let myUid = self.myUid {
            let followerRef = FirebaseDataService.instance.userRef.child(shownUid).child(Constants.Users.followers).child(myUid)
            followerRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    self.turnOnAndOffFollowButton(isOn: false)
                } else {
                    self.turnOnAndOffFollowButton(isOn: true)
                }
            })
        }
    }
    
    func changeFollowButtonState() {
        if let shownUid = self.userInfo?.uid, let myUid = self.myUid {
            let followingRef = FirebaseDataService.instance.userRef.child(myUid).child(Constants.Users.following).child(shownUid)
            let followerRef = FirebaseDataService.instance.userRef.child(shownUid).child(Constants.Users.followers).child(myUid)
            followerRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    self.observeChangeFollowing(follows: true, followee: shownUid, follower: myUid)
                    self.turnOnAndOffFollowButton(isOn: true)
                    followerRef.setValue(NSNumber(value: 1))
                    followingRef.setValue(NSNumber(value: 1))
                } else {
                    self.observeChangeFollowing(follows: false, followee: shownUid, follower: myUid)
                    self.turnOnAndOffFollowButton(isOn: false)
                    followerRef.removeValue()
                    followingRef.removeValue()
                }
            })
        }
    }
    
    func observeChangeFollowing(follows: Bool, followee: String, follower: String) {
        FirebaseDataService.instance.userRef.child(follower).child(Constants.Users.numFollowings).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? Int {
                self.userInfo?.changeNumFollowers(follows: follows, followee: followee, follower: follower, numFollowing: value)
                if let user = self.userInfo {
                    self.followersNumTextView.attributedText = self.putDashBoardAttributedText(number: user.numFollowers, type: "팔로워")
                }
            }
        })
    }
    
    func turnOnAndOffFollowButton(isOn: Bool) {
        if !isOn {
            self.followButton.setImage(UIImage(named: "icon small plus"), for: .normal)
            self.followButton.backgroundColor = .white
        } else {
            self.followButton.setImage(UIImage(named: "icon small plus white"), for: .normal)
            self.followButton.backgroundColor = UIColor.makeViaRgb(red: 0, green: 159, blue: 232)
        }
    }
    
    func commentButtonTapped() {
        
    }
    
    let dividerView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let dividerView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        label.textAlignment = .center
        label.text = "바견수"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 36)
        return label
    }()
    
    lazy var introTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .center
        textView.textColor = .lightGray
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        textView.text = "이것은 테스트 문자열입니다"
        return textView
    }()
    
    let commentsNumTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        textView.isEditable = false
        return textView
    }()
    
    let followersNumTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        textView.isEditable = false
        return textView
    }()
    
    let followingNumTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        textView.isEditable = false
        return textView
    }()
    
    
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        addSubViews()
        setConstraints()
    }
    
    fileprivate func addSubViews() {
        addSubview(userBackgroundImageView)
        addSubview(userProfileImageView)
        addSubview(followButton)
        addSubview(commentButton)
        addSubview(dividerView1)
        addSubview(dividerView2)
        addSubview(titleLabel)
        addSubview(introTextView)
        addSubview(commentsNumTextView)
        addSubview(followersNumTextView)
        addSubview(followingNumTextView)
    }

    fileprivate func setConstraints() {
        _ = userBackgroundImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.height / 2.4)
        
        _ = userProfileImageView.anchor(userBackgroundImageView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: -(Constants.userProfileImageSize.extra / 2), leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: Constants.userProfileImageSize.extra, heightConstant: Constants.userProfileImageSize.extra)
        
        addConstraint(NSLayoutConstraint(item: userProfileImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        _ = commentButton.anchor(userBackgroundImageView.bottomAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: nil, topConstant: -22, leftConstant: -22, bottomConstant: 0, rightConstant: 0, widthConstant: 44, heightConstant: 44)
        
        _ = followButton.anchor(commentButton.bottomAnchor, left: commentButton.leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: -22, bottomConstant: 0, rightConstant: 0, widthConstant: 44, heightConstant: 44)
        
        _ = titleLabel.anchor(userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        _ = introTextView.anchor(titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        _ = dividerView2.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = dividerView1.anchor(nil, left: leftAnchor, bottom: dividerView2.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 92, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = commentsNumTextView.anchor(dividerView1.bottomAnchor, left: leftAnchor, bottom: dividerView2.topAnchor, right: nil, topConstant: 18, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width / 3, heightConstant: 0)
        
        _ = followersNumTextView.anchor(dividerView1.bottomAnchor, left: commentsNumTextView.rightAnchor, bottom: dividerView2.topAnchor, right: nil, topConstant: 18, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width / 3, heightConstant: 0)
        
        _ = followingNumTextView.anchor(dividerView1.bottomAnchor, left: followersNumTextView.rightAnchor, bottom: dividerView2.topAnchor, right: nil, topConstant: 18, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width / 3, heightConstant: 0)
        
    }
}

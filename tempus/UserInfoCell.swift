//
//  UserInfoCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class UserInfoCell: BaseCell {

    var user: Users?
    
    var userId: String? {
        didSet {
            if let userId = userId {
                observeFirebaseValue(userId: userId)
            }
        }
    }
    
    func observeFirebaseValue(userId: String) {
        FirebaseDataService.instance.userRef.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? Dictionary<String, AnyObject> {
                
                let user = Users(uid: snapshot.key, data: value)
                self.userBackgroundImageView.imageUrlString = user.backgroundImageUrl
                self.userProfileImageView.imageUrlString = value[Constants.Users.imageUrl] as? String
                self.titleLabel.text = value[Constants.Users.username] as? String
                self.introTextView.text = value[Constants.Users.intro] as? String
                
                let numComments = value[Constants.Users.numComments] as? Int
                let numFollowers = value[Constants.Users.numFollowers] as? Int
                let numFollowings = value[Constants.Users.numFollowings] as? Int
                
                //self.setPersonalStatistics(numComments: numComments!, numFollowers: numFollowers, numFollowings: numFollowings)
            }
        })
    }
    
    func setPersonalStatistics(numComments: Int, numFollowers: Int, numFollowings: Int) {
    
        let attributedText = NSMutableAttributedString(string: "\(numComments)", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium),
            NSForegroundColorAttributeName: UIColor.black
            ])
        
        attributedText.append(NSAttributedString(string: "\n댓글", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.darkGray
            ]))
        
        // center alignment
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.string.characters.count))
        
        commentsNumTextView.attributedText = attributedText
    }
    
    let userBackgroundImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder1")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let userProfileImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder2")
        imageView.layer.cornerRadius = Constants.userProfileImageSize.extra / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 0.6
        return imageView
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "icon small plus")
        image?.resizableImage(withCapInsets: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230).cgColor
        button.layer.borderWidth = 0.4
        button.layer.cornerRadius = button.frame.width / 2
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon small comment"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230).cgColor
        button.layer.borderWidth = 0.4
        button.layer.cornerRadius = button.frame.width / 2
        return button
    }()
    
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
        //textView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        textView.isEditable = false
        
        let attributedText = NSMutableAttributedString(string: "000", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium),
            NSForegroundColorAttributeName: UIColor.black
            ])
        
        attributedText.append(NSAttributedString(string: "\n댓글", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.darkGray
            ]))
        
        // center alignment
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.string.characters.count))
        
        textView.attributedText = attributedText
        
        return textView
    }()
    
    let followersNumTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        textView.isEditable = false
        
        let attributedText = NSMutableAttributedString(string: "000", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium),
            NSForegroundColorAttributeName: UIColor.black
            ])
        
        attributedText.append(NSAttributedString(string: "\n팔로워", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.darkGray
            ]))
        
        // center alignment
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.string.characters.count))
        
        textView.attributedText = attributedText
        
        return textView
    }()
    
    let followingNumTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        textView.isEditable = false
        
        let attributedText = NSMutableAttributedString(string: "000", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium),
            NSForegroundColorAttributeName: UIColor.black
            ])
        
        attributedText.append(NSAttributedString(string: "\n팔로잉", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.darkGray
            ]))
        
        // center alignment
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.string.characters.count))
        
        textView.attributedText = attributedText
        
        return textView
    }()
    
    func followButtonTapped() {
        
    }
    
    func commentButtonTapped() {
        
    }
    
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

//
//  SlideCoverCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 11..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class SlideCoverCell: BaseCell {

    var titleLabelHeightConstraint: NSLayoutConstraint?
    var subTitleLabelHeightConstraint: NSLayoutConstraint?
    
    var meetingId: String? {
        didSet{
            observeFirebaseValue()
        }
    }
    
    func observeFirebaseValue() {
        if let id = self.meetingId {
            FirebaseDataService.instance.meetingRef.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? Dictionary<String, AnyObject> {
                    self.titleTextView.text = value[Constants.Meetings.title] as? String
                    self.subtitleTextView.text = value[Constants.Meetings.subTitle] as? String
                    
                    self.typeLabel.text = value[Constants.Meetings.type] as? String
                    
                    self.estimatingTextSize(text: (value[Constants.Meetings.title] as? String), unitSize: 26, constraint: self.titleLabelHeightConstraint)
                    self.estimatingTextSize(text: (value[Constants.Meetings.subTitle] as? String), unitSize: 20, constraint: self.subTitleLabelHeightConstraint)
                    
                    FirebaseDataService.instance.userRef.child((value[Constants.Meetings.userId] as? String)!).observeSingleEvent(of: .value, with: { (userSnap) in
                        if let userVal = userSnap.value as? Dictionary<String, AnyObject> {
                            self.userProfileImageView.imageUrlString = userVal[Constants.Users.imageUrl] as? String
                            self.giverLabel.text = (userVal[Constants.Users.username] as? String)!
                        }
                    })
                }
            })
        }
    }
    
    func estimatingTextSize(text: String?, unitSize: CGFloat, constraint: NSLayoutConstraint?) {
        if let title = text {
            let size = CGSize(width: self.frame.width - 18, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: unitSize)], context: nil)
            
            if estimatedRect.size.height > unitSize {
                titleLabelHeightConstraint?.constant = unitSize * 2
            } else {
                titleLabelHeightConstraint?.constant = unitSize
            }
        }
    }
    
    /*
     * UI Components
     */
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
    }()
    
    let userProfileImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder human")
        imageView.layer.cornerRadius = Constants.userProfileImageSize.lessSmall / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let giverLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 30)
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.text = "강교혁 기버와 함께하는 \n창업이야기"
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    lazy var subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textContainerInset = UIEdgeInsetsMake(0, 8, 0, 0)
        textView.textColor = .lightGray
        textView.backgroundColor = .clear
        textView.text = "강교혁 기버만이 가진 창업노하우를 같이 공유합니다"
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    func beforeButtonTapped() {
        
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .clear
        addSubViews()
        setContstraints()
    }
    
    fileprivate func addSubViews() {
        addSubview(overlayView)
        addSubview(dividerView)
        addSubview(userProfileImageView)
        addSubview(giverLabel)
        addSubview(subtitleTextView)
        addSubview(titleTextView)
        addSubview(typeLabel)
    }
    
    fileprivate func setContstraints() {
        _ = overlayView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = userProfileImageView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 14, bottomConstant: frame.height / 8, rightConstant: 0, widthConstant: Constants.userProfileImageSize.lessSmall, heightConstant: Constants.userProfileImageSize.lessSmall)
        
        _ = giverLabel.anchor(nil, left: userProfileImageView.rightAnchor, bottom: userProfileImageView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0 , rightConstant: 0, widthConstant: 200, heightConstant: 40)
        
        subTitleLabelHeightConstraint = subtitleTextView.anchor(nil, left: leftAnchor, bottom: userProfileImageView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 2, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 44).last
        
        titleLabelHeightConstraint = titleTextView.anchor(nil, left: leftAnchor, bottom: subtitleTextView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 6, rightConstant: 8, widthConstant: 0, heightConstant: 68).last
        
        _ = typeLabel.anchor(nil, left: leftAnchor, bottom: titleTextView.topAnchor, right: nil, topConstant: 0, leftConstant: 12, bottomConstant: 1, rightConstant: 0, widthConstant: 120, heightConstant: 24)
        
    }

    
    

}

//
//  SlideDetailCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 11..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class SlideDetailCell: BaseCell {

    struct SlideDetailData {
        static let defaultButtonHeight: CGFloat = 54
    }
    
    /*
     * UI Components
     */
    let mainImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder3")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userProfileImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder human")
        imageView.layer.cornerRadius = Constants.userProfileImageSize.big / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let giverLabel: UILabel = {
        let label = UILabel()
        label.text = "기버"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    lazy var introTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsetsMake(0, 8, 0, 0)
        textView.textColor = .lightGray
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1.4
        button.backgroundColor = UIColor.makeViaRgb(red: 74, green: 144, blue: 226)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = SlideDetailData.defaultButtonHeight / 2
        button.setTitle("팔로우 하기", for: .normal)
        button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230).cgColor
        button.layer.borderWidth = 1.4
        button.layer.cornerRadius = SlideDetailData.defaultButtonHeight / 2
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func followButtonTapped() {
        
    }
    
    func commentButtonTapped() {
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        addSubViews()
        setContstraints()
    }
    
    fileprivate func addSubViews() {
        addSubview(mainImageView)
        addSubview(userProfileImageView)
        addSubview(introTextView)
        addSubview(giverLabel)
        addSubview(followButton)
        addSubview(commentButton)
        addSubview(dividerView)
        
    }
    
    fileprivate func setContstraints() {
        _ = mainImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.height / 4)
        
        _ = userProfileImageView.anchor(mainImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: -32, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: Constants.userProfileImageSize.big, heightConstant: Constants.userProfileImageSize.big)
        
        _ = introTextView.anchor(nil, left: userProfileImageView.rightAnchor, bottom: userProfileImageView.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 22)

        _ = giverLabel.anchor(nil, left: userProfileImageView.rightAnchor, bottom: introTextView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 32)
        
        _ = commentButton.anchor(introTextView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: SlideDetailData.defaultButtonHeight, heightConstant: SlideDetailData.defaultButtonHeight)
        
        _ = followButton.anchor(introTextView.bottomAnchor, left: userProfileImageView.leftAnchor, bottom: nil, right: commentButton.leftAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: SlideDetailData.defaultButtonHeight)
        
        _ = dividerView.anchor(followButton.bottomAnchor, left: userProfileImageView.leftAnchor, bottom: nil, right: commentButton.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1.4)
    }

}

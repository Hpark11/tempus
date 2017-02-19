//
//  ChatMessageCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 19..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class ChatMessageCell: BaseCell {
    var containerViewWidthAnchor: NSLayoutConstraint?
    var containerViewRightAnchor: NSLayoutConstraint?
    var containerViewLeftAnchor: NSLayoutConstraint?
    let profileImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder human")
        imageView.layer.cornerRadius = Constants.userProfileImageSize.mini / 4
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 0.4
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let chattingTextView: UITextView = {
        let textView = UITextView()
        textView.text = "시험용 텍스트"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .white
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        return textView
    }()
    
    static let blueish = UIColor.makeViaRgb(red: 0, green: 137, blue: 249)
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 0, green: 137, blue: 249)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true

        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubViews()
        setConstriants()
        
    }
    
    fileprivate func addSubViews() {
        addSubview(containerView)
        addSubview(chattingTextView)
        addSubview(profileImageView)
        
    }
    
    fileprivate func setConstriants() {
        
        let anchors = containerView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 18, bottomConstant: 0, rightConstant: 8, widthConstant: 200, heightConstant: frame.height)
        containerViewWidthAnchor = anchors[3]
        containerViewRightAnchor = anchors[2]
        containerViewLeftAnchor = anchors[1]
        
        _ = chattingTextView.anchor(topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 2, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.height)
        
        _ = profileImageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: -8, leftConstant: -16, bottomConstant: 0, rightConstant: 0, widthConstant: Constants.userProfileImageSize.mini, heightConstant: Constants.userProfileImageSize.mini)
    }
}

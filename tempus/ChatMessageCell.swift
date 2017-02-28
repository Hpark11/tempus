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
    
    var fromUserId: String? {
        didSet {
            profileImageView.image = UIImage(named: "placeholder human")
            if let fromUserId = fromUserId {
                FirebaseDataService.instance.userRef.child(fromUserId).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let data = snapshot.value as? Dictionary<String, AnyObject> {
                        let user = Users(uid: snapshot.key, data: data)
                        self.profileImageView.imageUrlString = user.imageUrl
                    }
                })
            }
        }
    }
    
    let profileImageView = DownloadImageView()
//    {
//        let imageView = DownloadImageView()
//        imageView.image = UIImage(named: "placeholder human")
//        imageView.layer.cornerRadius = Constants.userProfileImageSize.mini / 4
//        imageView.layer.masksToBounds = true
//        imageView.layer.borderColor = UIColor.darkGray.cgColor
//        imageView.layer.borderWidth = 0.4
//        imageView.contentMode = .scaleAspectFill
//        //return imageView
//    }()
    
    let chattingTextView: UITextView = {
        let textView = UITextView()
        textView.text = "시험용 텍스트"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .white
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
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
        
        profileImageView.image = UIImage(named: "placeholder human")
        profileImageView.layer.cornerRadius = Constants.userProfileImageSize.mini / 4
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = UIColor.darkGray.cgColor
        profileImageView.layer.borderWidth = 0.4
        profileImageView.contentMode = .scaleAspectFill
        
        addSubViews()
        setConstriants()
    }
    
    fileprivate func addSubViews() {
        addSubview(containerView)
        addSubview(chattingTextView)
        addSubview(profileImageView)
        
    }
    
    
    override func layoutSubviews() {
        
    }
    
    var containerViewHeightAnchor: NSLayoutConstraint?
    var textViewHeightAnchor: NSLayoutConstraint?
    fileprivate func setConstriants() {
        
        let anchors = containerView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 18, bottomConstant: 0, rightConstant: 8, widthConstant: 200, heightConstant: frame.height)
        containerViewWidthAnchor = anchors[3]
        containerViewRightAnchor = anchors[2]
        containerViewLeftAnchor = anchors[1]
        containerViewHeightAnchor = anchors[4]
        textViewHeightAnchor = chattingTextView.anchor(topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 2, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.height)[3]
        
        _ = profileImageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: -16, bottomConstant: 0, rightConstant: 0, widthConstant: Constants.userProfileImageSize.mini, heightConstant: Constants.userProfileImageSize.mini)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.width = CGFloat(ceilf(Float(size.width)))
        newFrame.size.height = measuredFrameHeightForEachMessage(message: chattingTextView.text).height + 20
        containerViewHeightAnchor?.constant = measuredFrameHeightForEachMessage(message: chattingTextView.text).height + 20
        textViewHeightAnchor?.constant = measuredFrameHeightForEachMessage(message: chattingTextView.text).height + 20
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
    private func measuredFrameHeightForEachMessage(message: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: message).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}

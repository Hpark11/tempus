//
//  MeetingCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 10..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MeetingCell: BaseCell {
    
    /*
     *  UI Components
     */
    let mainImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userProfileImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder1")
        imageView.layer.cornerRadius = Constants.userProfileImageSize.small / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        textView.textColor = UIColor.lightGray
        return textView
    }()
    
    let giverLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        let attributedText = NSMutableAttributedString(string: "강교혁 기버", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)])
        attributedText.append(NSAttributedString(string: "\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, attributedText.string.characters.count))
        
        let attachmentHeart = NSTextAttachment()
        let attachmentComment = NSTextAttachment()
        attachmentHeart.image = UIImage(named: "placeholder1")
        attachmentHeart.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
        attachmentComment.image = UIImage(named: "placeholder2")
        attachmentComment.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
        
        attributedText.append(NSAttributedString(attachment: attachmentHeart))
        attributedText.append(NSAttributedString(string: " 233  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.lightGray]))
        attributedText.append(NSAttributedString(attachment: attachmentComment))
        attributedText.append(NSAttributedString(string: " 48 ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.lightGray]))
        label.attributedText = attributedText
        return label
    }()
    
    let meetingTypeLabel: UILabel = {
       let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "")
        
        let attachmentMeetingType = NSTextAttachment()
        attachmentMeetingType.image = UIImage(named: "placeholder3")
        attachmentMeetingType.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubViews()
        setConstraints()
    }
    
    fileprivate func addSubViews() {
        addSubview(mainImageView)
        addSubview(userProfileImageView)
        addSubview(giverLabel)
        addSubview(meetingTypeLabel)
    }
    
    fileprivate func setConstraints() {
        _ = mainImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: Constants.sizeStandards.spaceShort, leftConstant: Constants.sizeStandards.spaceShort, bottomConstant: 0, rightConstant: Constants.sizeStandards.spaceShort, widthConstant: 0, heightConstant: frame.width * Constants.sizeStandards.landscapeRatio)
        
        _ = userProfileImageView.anchor(mainImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: Constants.userProfileImageSize.small, heightConstant: Constants.userProfileImageSize.small)
        
        _ = giverLabel.anchor(mainImageView.bottomAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 140, heightConstant: 48)
        
        _ = meetingTypeLabel.anchor(mainImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 100, heightConstant: 28)
    }

    
}

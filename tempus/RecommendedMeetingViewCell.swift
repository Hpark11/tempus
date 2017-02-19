//
//  RecommendedMeetingViewCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 9..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class RecommendedMeetingViewCell: BaseCell {

    var meeting: MinimizedMeeting? {
        didSet {
            if let meeting = meeting {
                imageView.imageUrlString = meeting.imageUrl
                titleTextView.text = meeting.title
            }
        }
    }
    
    let imageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder2")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 28)
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .red
        
        addSubViews()
        setConstraints()
    }
    
    fileprivate func addSubViews() {
        addSubview(imageView)
        addSubview(titleTextView)
    }
    
    fileprivate func setConstraints() {
        _ = imageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = titleTextView.anchor(nil, left: imageView.leftAnchor, bottom: bottomAnchor, right: imageView.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 4, rightConstant: 8, widthConstant: 0, heightConstant: 60)
    }
    
}


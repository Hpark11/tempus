//
//  CommentCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 26..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    
    let userImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.4
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let commentTextLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageView?.layer.cornerRadius = 8
        
        textLabel?.text = "테스트"
        detailTextLabel?.text = "00:00:00"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addSubViews() {
        addSubview(userImageView)
    }
    
    var commentBottomConstraint: NSLayoutConstraint?
    
    fileprivate func setConstraints() {
        _ = userImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: Constants.userProfileImageSize.lessSmall, heightConstant: Constants.userProfileImageSize.lessSmall)
        
        _ = textLabel?.anchor(topAnchor, left: userImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 28)
        
        _ = detailTextLabel?.anchor(textLabel?.bottomAnchor, left: userImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 20)
        
        _ = commentTextLabel.anchor(detailTextLabel?.bottomAnchor, left: userImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 6, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 100)
        
    }
}

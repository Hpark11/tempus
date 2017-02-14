//
//  UserInfoCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class UserInfoCell: BaseCell {

    let userProfileImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder1")
        imageView.layer.cornerRadius = Constants.userProfileImageSize.big / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon plus"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = button.frame.width / 2
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon comment"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        button.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
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
        addSubview(userProfileImageView)
        addSubview(followButton)
        addSubview(commentButton)
        addSubview(dividerView1)
        addSubview(dividerView2)
        addSubview(titleLabel)
    }

    fileprivate func setConstraints() {
        
        _ = userProfileImageView.anchor(topAnchor, left: nil, bottom: nil, right: nil, topConstant: frame.height / 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: Constants.userProfileImageSize.big, heightConstant: Constants.userProfileImageSize.big)
        
        addConstraint(NSLayoutConstraint(item: userProfileImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        _ = followButton.anchor(topAnchor, left: nil, bottom: nil, right: userProfileImageView.leftAnchor, topConstant: frame.height / 5, leftConstant: 0, bottomConstant: 0, rightConstant: frame.width / 12, widthConstant: 75, heightConstant: 75)
        
        _ = commentButton.anchor(topAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: nil, topConstant: frame.height / 5, leftConstant: frame.width / 12, bottomConstant: 0, rightConstant: 0, widthConstant: 75, heightConstant: 75)
        
        _ = titleLabel.anchor(userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        _ = dividerView2.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = dividerView1.anchor(nil, left: leftAnchor, bottom: dividerView2.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 92, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
}

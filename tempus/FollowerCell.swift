//
//  FollowerCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 17..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class FollowerCell: UITableViewCell {
    
    let profileImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder human")
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.text = "박현수"
        return label
    }()
    
    let introLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.text = "이것은 텍스트 문자열입니다"
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addSubViews() {
        addSubview(profileImageView)
        addSubview(titleLabel)
        addSubview(introLabel)
    }
    
    fileprivate func setConstraints() {
        _ = profileImageView.anchor(nil, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 34, heightConstant: 34)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        _ = titleLabel.anchor(profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 6, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 22)
        
        _ = introLabel.anchor(titleLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 2, leftConstant: 6, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 14)
    }
}

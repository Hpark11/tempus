//
//  UserCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 16..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    struct UserData {
        static let profileImageSize: CGFloat = 48
        static let positionLabel: CGFloat = 64
    }
    
    let profileImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder human")
        imageView.layer.cornerRadius = UserData.profileImageSize / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 1.2
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: UserData.positionLabel, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: UserData.positionLabel, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        _ = profileImageView.anchor(nil, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: UserData.profileImageSize, heightConstant: UserData.profileImageSize)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

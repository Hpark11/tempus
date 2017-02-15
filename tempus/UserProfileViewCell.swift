//
//  UserProfileViewCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class UserProfileViewCell: BaseCell {
    
    let userProfileTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            userProfileTypeLabel.textColor = isHighlighted ? UIColor.black : UIColor.lightGray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            userProfileTypeLabel.textColor = isSelected ? UIColor.black : UIColor.lightGray
        }
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        
        addSubview(userProfileTypeLabel)
        
        _ = userProfileTypeLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}

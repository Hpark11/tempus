//
//  RecommendedMeetingViewCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 9..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class RecommendedMeetingViewCell: BaseCell {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder2")
        return imageView
    }()

    override func setupViews() {
        super.setupViews()
        
        addSubViews()
        setConstraints()
    }
    
    fileprivate func addSubViews() {
        addSubview(imageView)
    }
    
    fileprivate func setConstraints() {
        _ = imageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}


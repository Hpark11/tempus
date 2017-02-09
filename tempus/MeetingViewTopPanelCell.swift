//
//  MeetingViewTopPanelCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 8..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MeetingViewTopPanelCell: BaseCell {

    /*
     *  UI Components
     */
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "placeholder1")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubViews()
        setConstraints()
    }
    
    fileprivate func addSubViews() {
        addSubview(imageView)
        addSubview(overlayView)
    }
    
    fileprivate func setConstraints() {
        _ = imageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = overlayView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}

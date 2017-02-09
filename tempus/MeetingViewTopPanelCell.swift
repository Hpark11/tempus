//
//  MeetingViewTopPanelCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 8..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MeetingViewTopPanelCell: BaseCell {

    var content: MeetingTopPanelContent? {
        didSet {
            if let content = content {
                imageView.image = UIImage(named: content.imageName)
                titleLabel.text = content.title
            }
        }
    }
    
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        //label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(titleLabel)
    }
    
    fileprivate func setConstraints() {
        _ = imageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = overlayView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = titleLabel.anchor(nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}

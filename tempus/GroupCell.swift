//
//  GroupCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 22..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class GroupCell: UITableViewCell {
    
    var groupImageLeftAnchor: NSLayoutConstraint?
    var groupImageRightAnchor: NSLayoutConstraint?
    var overlayViewLeftAnchor: NSLayoutConstraint?
    var overlayViewRightAnchor: NSLayoutConstraint?
    var titleTextViewLeftAnchor: NSLayoutConstraint?
    var titleTextViewRightAnchor: NSLayoutConstraint?
    
    var index: Int? {
        didSet {
            if let index = self.index {
                if index % 2 == 0 {
                    groupImageLeftAnchor?.isActive = true
                    groupImageRightAnchor?.isActive = false
                    overlayViewLeftAnchor?.isActive = true
                    overlayViewRightAnchor?.isActive = false
                    titleTextViewLeftAnchor?.isActive = false
                    titleTextViewRightAnchor?.isActive = true
//                    titleTextViewLeftAnchor?.constant = 0
//                    titleTextViewRightAnchor?.constant = 0
                    self.titleTextView.textAlignment = .right
                } else {
                    groupImageLeftAnchor?.isActive = false
                    groupImageRightAnchor?.isActive = true
                    overlayViewLeftAnchor?.isActive = false
                    overlayViewRightAnchor?.isActive = true
                    titleTextViewLeftAnchor?.isActive = true
                    titleTextViewRightAnchor?.isActive = false
//                    titleTextViewLeftAnchor?.constant = 8
//                    titleTextViewRightAnchor?.constant = 0
                    self.titleTextView.textAlignment = .left
                }
            }
        }
    }
    
    var group: Group? {
        didSet {
            if let group = self.group {
                self.groupImageView.imageUrlString = group.imageUrl
                self.titleTextView.text = group.name
            }
        }
    }

    struct GroupData {
        static let profileImageSize: CGFloat = 48
        static let positionLabel: CGFloat = 64
    }
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 22)
        textView.textColor = UIColor.makeViaRgb(red: 36, green: 36, blue: 36)
        textView.textAlignment = .right
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    let groupImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder image")
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let overlayCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .white//UIColor.makeViaRgb(red: 0, green: 159, blue: 232)
        view.alpha = 0.3
        return view
    }()
    
    let gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = self.overlayView.bounds
        
        let color1 = UIColor.clear.cgColor as CGColor
        let color2 = UIColor.white.cgColor as CGColor
        //let color3 = UIColor.white.cgColor as CGColor
        //let color4 = UIColor.clear.cgColor as CGColor
        gradientLayer.colors = [color1, color2]//, color3, color4]
        //gradientLayer.locations = [0.0, 0.1, 0.9, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.overlayView.layer.addSublayer(gradientLayer)
    }
    
    func applyOverlayView(colorLeft: UIColor, colorRigth: UIColor) {
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubViews()
        setConstriants()
    }
    
    fileprivate func addSubViews() {
        addSubview(groupImageView)
        addSubview(overlayView)
        //addSubview(overlayCoverView)
        addSubview(titleTextView)
        addSubview(timeLabel)
    }
    
    
    
    fileprivate func setConstriants() {
        let groupImageViewAnchors = groupImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width * 0.64, heightConstant: 0)
        
        groupImageLeftAnchor = groupImageViewAnchors[1]
        groupImageRightAnchor = groupImageViewAnchors[3]
        

        let overlayViewAnchors = overlayView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width * 0.64, heightConstant: 0)
        
        overlayViewLeftAnchor = overlayViewAnchors[1]
        overlayViewRightAnchor = overlayViewAnchors[3]
        
        //_ = overlayCoverView.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: overlayView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width * 0.2, heightConstant: 0)
        
        let titleTextViewAnchors = titleTextView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: frame.width * 0.6, heightConstant: 0)
        
        titleTextViewLeftAnchor = titleTextViewAnchors[1]
        titleTextViewRightAnchor = titleTextViewAnchors[3]
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


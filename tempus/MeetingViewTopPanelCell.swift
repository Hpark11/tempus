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
                //titleLabel.text = content.title
                
                let attributedText = NSMutableAttributedString(string: content.title, attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium),
                    NSForegroundColorAttributeName: UIColor.white
                    ])
                
                // center alignment
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.string.characters.count))
                
                titleView.attributedText = attributedText
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
    
    let titleView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        textView.isEditable = false
        return textView
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
        addSubview(titleView)
    }
    
    fileprivate func setConstraints() {
        _ = imageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = overlayView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = titleView.anchor(nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        titleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        addConstraint(NSLayoutConstraint(item: titleView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: frame.size.height / 3.4))
    }
}

//
//  OnboardingCoverPageCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 8..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class OnboardingCoverPageCell: BaseCell {

    var page: OnboardingPage? {
        didSet {
            guard let page = page else {
                return
            }
            
            imageView.image = UIImage(named: page.imageName)
            
            let attributedText = NSMutableAttributedString(string: page.title, attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 32, weight: UIFontWeightMedium),
                NSForegroundColorAttributeName: UIColor.white
                ])
            
            attributedText.append(NSAttributedString(string: "\n\n\(page.message)", attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 18),
                NSForegroundColorAttributeName: UIColor.white
                ]))
            
            // center alignment
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.string.characters.count))
            
            textView.attributedText = attributedText
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "page1")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        textView.isEditable = false
        textView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubViews()
        setConstraints()
    }

    fileprivate func addSubViews() {
        addSubview(imageView)
        addSubview(textView)
    }
    
    fileprivate func setConstraints() {
        imageView.anchorToTop(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        textView.anchorWithConstantsToTop(nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        addConstraint(NSLayoutConstraint(item: textView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}

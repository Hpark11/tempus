//
//  SlideCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 11..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class SlideCell: BaseCell {

    var meetingId: String?
    var slideId: String? {
        didSet {
            observeFirebaseValue()
        }
    }
    
    func observeFirebaseValue() {
        if let id = slideId, let meetingId = self.meetingId {
            FirebaseDataService.instance.meetingRef.child(meetingId).child(Constants.Meetings.slides).child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? Dictionary<String, AnyObject> {
                    self.mainImageView.imageUrlString = value[Constants.Meetings.Slides.imageUrl] as? String
                    self.configureContentText(title: (value[Constants.Meetings.Slides.storyTitle] as? String), subTitle: (value[Constants.Meetings.Slides.storySubtitle] as? String))
                }
            })
        }
    }
    
    func configureContentText(title: String?, subTitle: String?) {
        if let titleText = title, let subTitleText = subTitle {
            let attributedText = NSMutableAttributedString(string: titleText, attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 32, weight: UIFontWeightMedium),
                NSForegroundColorAttributeName: UIColor.white
            ])
            attributedText.append(NSAttributedString(string: "\n\n\(subTitleText)", attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 18),
                NSForegroundColorAttributeName: UIColor.white
            ]))
            mainTextView.attributedText = attributedText
        }
    }
    
    /*
     * UI Components
     */
    let overlayView: UIView = {
        let view = UIView()
        //view.backgroundColor = .black
        //view.alpha = 0.6
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        return view
    }()
    
    let mainImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 1.0
        imageView.layer.shadowRadius = 10.0
        imageView.layer.shadowOffset = CGSize(width: 0.2, height: 4.0)
        return imageView
    }()
    
    
    lazy var mainTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 28)
        textView.textContainerInset = UIEdgeInsetsMake(26, 8, 8, 8)
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        return textView
    }()

    override func setupViews() {
        super.setupViews()
        addSubViews()
        setContstraints()
    }
    
    fileprivate func addSubViews() {
        addSubview(overlayView)
        addSubview(mainTextView)
        addSubview(mainImageView)
    }
    
    fileprivate func setContstraints() {
        _ = overlayView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = mainImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 80, leftConstant: 26, bottomConstant: 0, rightConstant: 26, widthConstant: 0, heightConstant: frame.height / 2 - 80)
        
        _ = mainTextView.anchor(mainImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: -18, leftConstant: 16, bottomConstant: 24, rightConstant: 16, widthConstant: 0, heightConstant: 0)
    }
    
    
}

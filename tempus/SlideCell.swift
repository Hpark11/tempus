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
                NSForegroundColorAttributeName: UIColor.black
            ])
            
            attributedText.append(NSAttributedString(string: "\n\n\(subTitleText)", attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 18),
                NSForegroundColorAttributeName: UIColor.black
            ]))
            
            // center alignment
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.alignment = .center
//            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.string.characters.count))
            
            mainTextView.attributedText = attributedText
        }
    }
    
    /*
     * UI Components
     */
    let overlayView: UIView = {
        let view = UIView()
//        view.backgroundColor = .black
//        view.alpha = 0.3
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
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
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 14
        return imageView
    }()
    
    
    lazy var mainTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 28)
        textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8)
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.text = "이것은 테스트용 입니다"
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 14
        textView.layer.borderColor = UIColor.lightGray.cgColor
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
        
        _ = mainTextView.anchor(mainImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: -10, leftConstant: 16, bottomConstant: 24, rightConstant: 16, widthConstant: 0, heightConstant: 0)
    }
    
    
}

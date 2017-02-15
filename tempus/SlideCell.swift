//
//  SlideCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 11..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class SlideCell: BaseCell {

    /*
     * UI Components
     */
    let mainImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder3")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userProfileImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder1")
        imageView.layer.cornerRadius = Constants.userProfileImageSize.mini / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let giverLabel: UILabel = {
        let label = UILabel()
        label.text = "강교혁 기버"
        label.textColor = .cyan
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 28)
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.text = "강교혁 기버와 함께하는 \n창업이야기"
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    lazy var subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        //textView.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 0)
        textView.textColor = .lightGray
        textView.backgroundColor = .clear
        textView.text = "강교혁 기버만이 가진 창업노하우를 같이 공유합니다"
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let pageLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 10"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubViews()
        setContstraints()
    }
    
    fileprivate func addSubViews() {
        
        addSubview(mainImageView)
        addSubview(pageLabel)
        addSubview(dividerView)
        addSubview(userProfileImageView)
        addSubview(giverLabel)
        addSubview(subtitleTextView)
        addSubview(titleTextView)
    }
    
    fileprivate func setContstraints() {
        _ = mainImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = pageLabel.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 20, rightConstant: 16, widthConstant: 0, heightConstant: 24)
        
        _ = dividerView.anchor(nil, left: leftAnchor, bottom: pageLabel.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 14, rightConstant: 8, widthConstant: 0, heightConstant: 1)
        
        _ = userProfileImageView.anchor(nil, left: leftAnchor, bottom: dividerView.topAnchor, right: nil, topConstant: 0, leftConstant: 12, bottomConstant: 36, rightConstant: 0, widthConstant: Constants.userProfileImageSize.mini, heightConstant: Constants.userProfileImageSize.mini)
        
        _ = giverLabel.anchor(nil, left: userProfileImageView.rightAnchor, bottom: dividerView.topAnchor, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 30, rightConstant: 0, widthConstant: 80, heightConstant: 40)
        
        _ = subtitleTextView.anchor(nil, left: leftAnchor, bottom: userProfileImageView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 48)
        
        _ = titleTextView.anchor(nil, left: leftAnchor, bottom: subtitleTextView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 4, rightConstant: 8, widthConstant: 0, heightConstant: 64)
    }
    
    
}

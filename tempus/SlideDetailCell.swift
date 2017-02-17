//
//  SlideDetailCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 11..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class SlideDetailCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    struct SlideDetailData {
        static let defaultButtonHeight: CGFloat = 44
        static let cellId: String = "cellId"
    }
    
    lazy var giverInfollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
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
        imageView.layer.cornerRadius = Constants.userProfileImageSize.middle / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let giverLabel: UILabel = {
        let label = UILabel()
        label.text = "기버"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    lazy var introTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsetsMake(0, 8, 0, 0)
        textView.textColor = .lightGray
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        textView.text = "이것은 테스트 문자열입니다"
        return textView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1.0
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.titleLabel?.textColor = .darkGray
        button.layer.cornerRadius = SlideDetailData.defaultButtonHeight / 2
        button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.titleLabel?.text = "follow"
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon comment"), for: .normal)
        button.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = SlideDetailData.defaultButtonHeight / 2
        return button
    }()
    
    func followButtonTapped() {
        
    }
    
    func commentButtonTapped() {
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        addSubViews()
        setContstraints()
        registerCells()
    }
    
    fileprivate func addSubViews() {
        addSubview(mainImageView)
        addSubview(userProfileImageView)
        addSubview(introTextView)
        addSubview(giverLabel)
        addSubview(followButton)
        addSubview(commentButton)
        addSubview(dividerView)
        addSubview(giverInfollectionView)
    }
    
    fileprivate func setContstraints() {
        _ = mainImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.height / 4)
        
        _ = userProfileImageView.anchor(mainImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: -24, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: Constants.userProfileImageSize.middle, heightConstant: Constants.userProfileImageSize.middle)
        
        _ = introTextView.anchor(nil, left: userProfileImageView.rightAnchor, bottom: userProfileImageView.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 22)

        _ = giverLabel.anchor(nil, left: userProfileImageView.rightAnchor, bottom: introTextView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 32)
        
        _ = commentButton.anchor(introTextView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: SlideDetailData.defaultButtonHeight, heightConstant: SlideDetailData.defaultButtonHeight)
        
        _ = followButton.anchor(introTextView.bottomAnchor, left: userProfileImageView.leftAnchor, bottom: nil, right: commentButton.leftAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: SlideDetailData.defaultButtonHeight)
        
        _ = dividerView.anchor(followButton.bottomAnchor, left: userProfileImageView.leftAnchor, bottom: nil, right: commentButton.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1.4)
        
        _ = giverInfollectionView.anchor(dividerView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func registerCells() {
        giverInfollectionView.register(MeetingGiverDetailCell.self, forCellWithReuseIdentifier: SlideDetailData.cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideDetailData.cellId, for: indexPath) as! MeetingGiverDetailCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height * 1.2)
    }
}

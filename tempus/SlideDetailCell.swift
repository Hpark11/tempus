//
//  SlideDetailCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 11..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class SlideDetailCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var attachedViewController: SlideViewController?
    
    struct SlideDetailData {
        static let defaultButtonHeight: CGFloat = 44
        static let cellId: String = "cellId"
    }
    
    var meetingId: String? {
        didSet{
            observeFirebaseValue()
        }
    }
    func observeFirebaseValue() {
        if let id = self.meetingId {
            FirebaseDataService.instance.meetingRef.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? Dictionary<String, AnyObject> {
                    
                    FirebaseDataService.instance.userRef.child((value[Constants.Meetings.userId] as? String)!).observeSingleEvent(of: .value, with: { (userSnap) in
                        if let userVal = userSnap.value as? Dictionary<String, AnyObject> {
                            self.mainImageView.imageUrlString = userVal[Constants.Users.backgroundImageUrl] as? String
                            self.userProfileImageView.imageUrlString = userVal[Constants.Users.imageUrl] as? String
                            self.giverLabel.text = userVal[Constants.Users.username] as? String
                            self.introTextView.text = userVal[Constants.Users.intro] as? String
                        }
                        
                        DispatchQueue.main.async(execute: { 
                            self.giverInfollectionView.reloadData()
                        })
                    })
                }
            })
        }
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
        label.text = ""
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    lazy var introTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsetsMake(0, 4, 0, 0)
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
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.makeViaRgb(red: 74, green: 144, blue: 226)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        button.setTitle("유저정보 확인하기", for: .normal)
        return button
    }()
    
    func followButtonTapped() {
        let layout = UICollectionViewFlowLayout()
        let checkUserProfileViewController = CheckUserProfileViewController(collectionViewLayout: layout)
        if let attachedViewController = self.attachedViewController {
            attachedViewController.present(checkUserProfileViewController, animated: true, completion: nil)
        }
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
        addSubview(dividerView)
        addSubview(giverInfollectionView)
    }
    
    fileprivate func setContstraints() {
        _ = mainImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.height / 4)
        
        _ = userProfileImageView.anchor(mainImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: -24, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: Constants.userProfileImageSize.middle, heightConstant: Constants.userProfileImageSize.middle)
        
        _ = introTextView.anchor(nil, left: userProfileImageView.rightAnchor, bottom: userProfileImageView.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 6, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 22)

        _ = giverLabel.anchor(nil, left: userProfileImageView.rightAnchor, bottom: introTextView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 32)

        _ = followButton.anchor(introTextView.bottomAnchor, left: userProfileImageView.leftAnchor, bottom: nil, right: rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 38)
        
        _ = dividerView.anchor(followButton.bottomAnchor, left: userProfileImageView.leftAnchor, bottom: nil, right: followButton.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1.4)
        
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
        if let attachedViewController = self.attachedViewController {
            cell.attachedViewController = attachedViewController
        }
        
        if let meetingId = self.meetingId {
            cell.meetingId = meetingId
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height * 1.0)
    }
}

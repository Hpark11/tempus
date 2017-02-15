//
//  UserMeetingCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class UserMeetingCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var didLaunchMeeting: [MinimizedMeeting]?
    var didTakeMeeting: [MinimizedMeeting]?
    
    struct UserMeetingData {
        static let didLaunchCellId = "didLaunchCellId"
        static let didTakeCellId = "didTakeCellId"
    }
    
    let panelView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var didLaunchMeetingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var didTakeMeetingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var didLaunchLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "내가 개설한 만남"
        return label
    }()
    
    lazy var didTakeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "내가 참석한 만남"
        return label
    }()
    
    lazy var changeProfileButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = UIColor.makeViaRgb(red: 34, green: 73, blue: 143)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(changeProfileButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        button.titleLabel?.text = "프로필 수정하기"
        button.setTitle("프로필 수정하기", for: .normal)
        return button
    }()
    
    func changeProfileButtonTapped() {
        
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        
        addSubViews()
        setConstraints()
        registerCells()
    }

    fileprivate func addSubViews() {
        addSubview(panelView)
        addSubview(didLaunchLabel)
        addSubview(didLaunchMeetingCollectionView)
        addSubview(didTakeLabel)
        addSubview(didTakeMeetingCollectionView)
        addSubview(changeProfileButton)
    }
    
    fileprivate func setConstraints() {
        _ = panelView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        _ = didLaunchLabel.anchor(topAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 36)
        
        _ = didLaunchMeetingCollectionView.anchor(didLaunchLabel.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
        
        _ = didTakeLabel.anchor(didLaunchMeetingCollectionView.topAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 36)
        
        _ = didTakeMeetingCollectionView.anchor(didLaunchLabel.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
        
        _ = changeProfileButton.anchor(nil, left: panelView.leftAnchor, bottom: panelView.bottomAnchor, right: panelView.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 42, rightConstant: 16, widthConstant: 0, heightConstant: 48)
    }
    
    fileprivate func registerCells() {
        didLaunchMeetingCollectionView.register(MinimizedMeetingCell.self, forCellWithReuseIdentifier: UserMeetingData.didLaunchCellId)
        didTakeMeetingCollectionView.register(MinimizedMeetingCell.self, forCellWithReuseIdentifier: UserMeetingData.didTakeCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == didLaunchMeetingCollectionView {
            if let meetings = didLaunchMeeting {
                return meetings.count
            }
        } else if collectionView == didTakeMeetingCollectionView {
            if let meetings = didTakeMeeting {
                return meetings.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == didLaunchMeetingCollectionView {
            if let meetings = didLaunchMeeting {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserMeetingData.didLaunchCellId, for: indexPath) as! MinimizedMeetingCell
                cell.meeting = meetings[indexPath.item]
                return cell
            }
        } else if collectionView == didTakeMeetingCollectionView {
            if let meetings = didTakeMeeting {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserMeetingData.didLaunchCellId, for: indexPath) as! MinimizedMeetingCell
                cell.meeting = meetings[indexPath.item]
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
}

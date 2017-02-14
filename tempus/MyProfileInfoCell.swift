//
//  MyProfileInfoCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MyProfileInfoCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    struct MyProfileInfoData {
        static let userInfoCellId = "userInfoCellId"
        static let userMeetingCellId = "userMeetingCellId"
        
    }
    
    lazy var meetingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    override func setupViews() {
        super.setupViews()
        addSubViews()
        setConstraints()
        registerCells()
    }
    
    fileprivate func addSubViews() {
        addSubview(meetingCollectionView)
    }
    
    fileprivate func setConstraints() {
        _ = meetingCollectionView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func registerCells() {
        meetingCollectionView.register(UserInfoCell.self, forCellWithReuseIdentifier: MyProfileInfoData.userInfoCellId)
        meetingCollectionView.register(UserMeetingCell.self, forCellWithReuseIdentifier: MyProfileInfoData.userMeetingCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyProfileInfoData.userInfoCellId, for: indexPath) as! UserInfoCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyProfileInfoData.userMeetingCellId, for: indexPath) as! UserMeetingCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: frame.width, height: frame.height / 1.4)
        } else {
            return CGSize(width: frame.width, height: frame.height)
        }
    }
}

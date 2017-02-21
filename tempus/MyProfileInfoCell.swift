//
//  MyProfileInfoCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class MyProfileInfoCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var attachedViewController: UserPageViewController?
    var isModifyMode: Bool = false
    
    struct MyProfileInfoData {
        static let userInfoCellId = "userInfoCellId"
        static let userMeetingCellId = "userMeetingCellId"
        static let userProfileModifyCellId = "userProfileModifyCellId"
    }
    var userInfo: Users?
    
    func observeFirebaseValue(userId: String) {
        if let userId = FIRAuth.auth()?.currentUser?.uid {
            FirebaseDataService.instance.userRef.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? Dictionary<String, AnyObject> {
                    self.userInfo = Users(uid: snapshot.key, data: value)
                    self.meetingCollectionView.reloadData()
                }
            })
        }
    }
    
    lazy var meetingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func setupViews() {
        super.setupViews()
        if let userId = FIRAuth.auth()?.currentUser?.uid {
            observeFirebaseValue(userId: userId)
        }
        
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
        meetingCollectionView.register(UserProfileModifyCell.self, forCellWithReuseIdentifier: MyProfileInfoData.userProfileModifyCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyProfileInfoData.userInfoCellId, for: indexPath) as! UserInfoCell
            cell.myUid = userInfo?.uid
            cell.userInfo = userInfo
            if let attachedViewController = self.attachedViewController {
                cell.attachedViewController = attachedViewController
            }
            return cell
        } else {
            if isModifyMode == true {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyProfileInfoData.userProfileModifyCellId, for: indexPath) as! UserProfileModifyCell
                cell.userInfo = userInfo
                cell.attachedCell = self
                if let attachedViewController = self.attachedViewController {
                    cell.attachedViewController = attachedViewController
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyProfileInfoData.userMeetingCellId, for: indexPath) as! UserMeetingCell
                cell.userInfo = userInfo
                cell.attachedCell = self
                if let attachedViewController = self.attachedViewController {
                    cell.attachedViewController = attachedViewController
                }
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: frame.width, height: frame.height / 1.1)
        } else {
            return CGSize(width: frame.width, height: frame.height)
        }
    }
}

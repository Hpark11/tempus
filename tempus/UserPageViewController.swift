//
//  UserPageViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class UserPageViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    struct UserPageData {
        static let myInfoCellId = "myInfoCellId"
        static let followingCellId = "followingCellId"
        static let cellIds = [myInfoCellId, followingCellId]
        static let categoryBarSize: CGFloat = 50.0
    }
    
    lazy var userProfileBarView: UserProfileBarView = {
        let view = UserProfileBarView()
        view.attachedViewController = self
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var signOutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon signout"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 28)
        button.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    func signOutButtonTapped() {
        do {
            try FIRAuth.auth()?.signOut()
            KeychainWrapper.standard.removeObject(forKey: Constants.keychainUid)
            _ = navigationController?.popViewController(animated: true)
        } catch {
            let error = error as NSError
            print(":::[HPARK] Sign Out Failure \(error) :::\n")
        }
    }
    
    func scrollToCategoryIndex(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = true
        
        setNavigationBarUI()
        addSubViews()
        setConstraints()
        registerCells()
    }

    fileprivate func setNavigationBarUI() {
        navigationItem.titleView = titleLabel
        let signOutButtonItem = UIBarButtonItem(customView: signOutButton)
        self.navigationItem.leftBarButtonItem = signOutButtonItem
    }
    
    fileprivate func addSubViews() {
        view.addSubview(userProfileBarView)
        view.addSubview(dividerView)
    }
    
    fileprivate func setConstraints() {
        _ = userProfileBarView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: UserPageData.categoryBarSize)
        
        _ = dividerView.anchor(userProfileBarView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = collectionView?.anchor(dividerView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func registerCells() {
        collectionView?.register(MyProfileInfoCell.self, forCellWithReuseIdentifier: UserPageData.myInfoCellId)
        collectionView?.register(UserFollowingCell.self, forCellWithReuseIdentifier: UserPageData.followingCellId)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserPageData.cellIds.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPageData.myInfoCellId, for: indexPath) as! MyProfileInfoCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPageData.followingCellId, for: indexPath) as! UserFollowingCell
            return cell
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        userProfileBarView.profileHighlightedBarConstraint?.constant = scrollView.contentOffset.x / CGFloat(UserPageData.cellIds.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
}

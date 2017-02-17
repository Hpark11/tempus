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
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 26))
        label.font = UIFont(name: "GothamRounded-Bold", size: 24)
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
        
        return label
    }()
    
    func scrollToCategoryIndex(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
    }
    
    func setTabBarVisibility(isHidden: Bool, animated: Bool) {
        let tabBar = self.tabBarController?.tabBar
        if tabBar?.isHidden == isHidden {
            return
        }
        let frame = tabBar?.frame
        let offset = (isHidden ? (frame?.size.height)! : -(frame?.size.height)!)
        let duration: TimeInterval = (animated ? 0.5 : 0.0)
        tabBar?.isHidden = false
        if frame != nil
        {
            UIView.animate(withDuration: duration, animations: {
                tabBar?.frame = (frame?.offsetBy(dx: 0, dy: offset))!
            }, completion: {
                if $0 {
                    tabBar?.isHidden = isHidden
                }
            })
        }
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
        navigationController?.navigationBar.tintColor = .white
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon signout solid"), style: .plain, target: self, action: #selector(signOutButtonTapped))
    }
    
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
    
    fileprivate func addSubViews() {
        view.addSubview(userProfileBarView)
    }
    
    fileprivate func setConstraints() {
        _ = userProfileBarView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: UserPageData.categoryBarSize)
        
        _ = collectionView?.anchor(userProfileBarView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
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
            cell.attachedViewController = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPageData.followingCellId, for: indexPath) as! UserFollowingCell
            cell.attachedViewController = self
            return cell
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        userProfileBarView.profileHighlightedBarConstraint?.constant = scrollView.contentOffset.x / CGFloat(UserPageData.cellIds.count)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        userProfileBarView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
    

}

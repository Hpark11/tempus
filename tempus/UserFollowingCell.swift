//
//  UserFollowingCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class UserFollowingCell: BaseCell, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var attachedViewController: UserPageViewController?

    let followersCellId = "followersCellId"
    let followingCellId = "followingCellId"
    
    var users = Dictionary<String, Users>()
    
    var followers = [Users]()
    var following = [Users]()
    //var users = [Users]()
    
    let dividerView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let dividerView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let dividerView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    

    let sectionFollowerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let sectionFollowingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    lazy var followersTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var followingTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon search black")
        return imageView
    }()
    
    lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "이름을 입력해주세요"
        textField.delegate = self
        return textField
    }()
    
    let followerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "나를 팔로잉하는 분들"
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "내가 팔로잉하는 분들"
        return label
    }()
    
    func observeFirebaseValue() {
        FirebaseDataService.instance.userRef.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for one in snapshot {
                    if let data = one.value as? Dictionary<String, AnyObject> {
                        let user = Users(uid: one.key, data: data)
                        self.users[one.key] = user
                    }
                }
            }
            
            if let userId = FIRAuth.auth()?.currentUser?.uid {
                if let following = self.users[userId]?.following {
                    for (key, _) in following {
                        self.following.append(self.users[key]!)
                    }
                }
                
                if let followers = self.users[userId]?.followers {
                    for (key, _) in followers {
                        self.followers.append(self.users[key]!)
                    }
                }
            }
            
            self.followersTableView.reloadData()
            self.followingTableView.reloadData()
        })
    }
    
    override func setupViews() {
        super.setupViews()
    
        addSubViews()
        setConstraints()
        registerCells()
        observeFirebaseValue()
    }
    
    fileprivate func addSubViews() {
        addSubview(dividerView1)
        addSubview(dividerView2)
        addSubview(dividerView3)
        addSubview(iconView)
        addSubview(searchField)
        addSubview(sectionFollowerView)
        addSubview(sectionFollowingView)
        addSubview(followingTableView)
        addSubview(followersTableView)
        addSubview(followerLabel)
        addSubview(followingLabel)
    }
    
    fileprivate func setConstraints() {
        _ = dividerView1.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = iconView.anchor(dividerView1.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 28, heightConstant: 28)
        
        _ = searchField.anchor(iconView.centerYAnchor, left: iconView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: -18, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 36)
        
        _ = dividerView2.anchor(searchField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = sectionFollowerView.anchor(dividerView2.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        _ = followerLabel.anchor(sectionFollowerView.topAnchor, left: sectionFollowerView.leftAnchor, bottom: sectionFollowerView.bottomAnchor, right: sectionFollowerView.rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = followersTableView.anchor(sectionFollowerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.height / 3)
        
        _ = dividerView3.anchor(followersTableView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = sectionFollowingView.anchor(dividerView3.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        _ = followingTableView.anchor(sectionFollowingView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = followingLabel.anchor(sectionFollowingView.topAnchor, left: sectionFollowingView.leftAnchor, bottom: sectionFollowingView.bottomAnchor, right: sectionFollowingView.rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func registerCells() {
        followersTableView.register(FollowerCell.self, forCellReuseIdentifier: followersCellId)
        followingTableView.register(FollowerCell.self, forCellReuseIdentifier: followingCellId)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let attachedViewController = self.attachedViewController {
            attachedViewController.setTabBarVisibility(isHidden: true, animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let attachedViewController = self.attachedViewController {
            searchField.resignFirstResponder()
            attachedViewController.setTabBarVisibility(isHidden: false, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let attachedViewController = self.attachedViewController {
            searchField.resignFirstResponder()
            attachedViewController.setTabBarVisibility(isHidden: false, animated: true)
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if followersTableView == tableView {
            return followers.count
        } else {
            return following.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == followersTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: followersCellId, for: indexPath) as! FollowerCell
            cell.userInfo = self.followers[indexPath.item]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: followingCellId, for: indexPath) as! FollowerCell
            cell.userInfo = self.following[indexPath.item]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

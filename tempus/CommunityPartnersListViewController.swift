//
//  CommunityPartnersListViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 20..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class CommunityPartnersListViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    let partnersCellId = "partnersCellId"
    let wannabeCellId = "wannabeCellId"
    
    var meetingId: String? {
        didSet {
            if let meetingId = meetingId {
                self.observeFirebaseValue(meetingId: meetingId)
            }
        }
    }
    var users = Dictionary<String, Users>()
    
    var partners = [Users]()
    var wannabe = [Users]()
    
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
    
    let mainImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder3")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    let sectionPartnersView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        view.alpha = 0.4
        return view
    }()
    
    let sectionWannabeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        view.alpha = 0.4
        return view
    }()
    
    lazy var partnersTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    lazy var wannabeTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.backgroundColor = .clear
        return label
    }()
    
    let creatorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .lightGray
        label.backgroundColor = .clear
        return label
    }()
    
    let membersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .lightGray
        label.backgroundColor = .clear
        return label
    }()
    
    let partnersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = .clear
        label.text = "함께하는 이들"
        return label
    }()
    
    let wannabeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = .clear
        label.text = "가입을 원하는 이들"
        return label
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 26))
        label.font = UIFont(name: "GothamRounded-Bold", size: 24)
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
        return label
    }()
    
    func observeFirebaseValue(meetingId: String) {
        FirebaseDataService.instance.userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? Dictionary<String, AnyObject> {
                for (key, value) in data {
                    if let userInfo = value as? Dictionary<String, AnyObject> {
                        let user = Users(uid: key, data: userInfo)
                        self.users[key] = user
                    }
                }
            }
            self.getPartnersAndWannabe(meetingId: meetingId)
        })
    }

    func getPartnersAndWannabe(meetingId: String) {
        self.wannabe.removeAll()
        self.partners.removeAll()
        
        FirebaseDataService.instance.meetingRef.child(meetingId).observeSingleEvent(of: .value, with: { (snapMeeting) in
            if let meeting = snapMeeting.value as? Dictionary<String, AnyObject> {
                if let title = meeting[Constants.Meetings.title] as? String {
                    self.titleLabel.text = title
                }
                
                if let imageUrl = meeting[Constants.Meetings.frontImageUrl] as? String {
                    self.mainImageView.imageUrlString = imageUrl
                }
                
                if let partners = meeting[Constants.Meetings.partners] as? Array<String> {
                    for key in partners {
                        if let user = self.users[key] {
                            self.partners.append(user)
                        }
                    }
                }
                
                if let wannabe = meeting[Constants.Meetings.wannabe] as? Array<String> {
                    for key in wannabe {
                        if let user = self.users[key] {
                            self.wannabe.append(user)
                        }
                    }
                }
                
                if let creatorId = meeting[Constants.Meetings.userId] as? String {
                    if let name = self.users[creatorId]?.username {
                        self.creatorLabel.text = "만든이 : " + name
                    }
                }
                
                self.membersLabel.text = "현재 멤버 수 : \(self.partners.count) 명"
            }
            DispatchQueue.main.async(execute: {
                self.partnersTableView.reloadData()
                self.wannabeTableView.reloadData()
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setConstraints()
        registerCells()
        setNavigationBarUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate func setNavigationBarUI() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.titleView = logoLabel
        self.navigationItem.title = ""
    }
    
    fileprivate func addSubViews() {
        view.addSubview(mainImageView)
        view.addSubview(overlayView)
        view.addSubview(titleLabel)
        view.addSubview(creatorLabel)
        view.addSubview(membersLabel)
        view.addSubview(partnersLabel)
        view.addSubview(wannabeLabel)
        view.addSubview(dividerView1)
        view.addSubview(dividerView2)
        view.addSubview(dividerView3)
        view.addSubview(sectionPartnersView)
        view.addSubview(sectionWannabeView)
        view.addSubview(partnersTableView)
        view.addSubview(wannabeTableView)
    }
    
    fileprivate func setConstraints() {
        _ = mainImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = overlayView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = titleLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        _ = creatorLabel.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom:nil, right: titleLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 22)
        
        _ = membersLabel.anchor(creatorLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom:nil, right: titleLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 22)
        
        _ = dividerView1.anchor(membersLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = sectionPartnersView.anchor(dividerView1.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 32)
        
        _ = partnersLabel.anchor(sectionPartnersView.topAnchor, left: sectionPartnersView.leftAnchor, bottom: sectionPartnersView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 0)
        
        _ = partnersTableView.anchor(sectionPartnersView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 160)
        
        _ = dividerView3.anchor(partnersTableView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = sectionWannabeView.anchor(dividerView3.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 32)
        
        _ = wannabeLabel.anchor(sectionWannabeView.topAnchor, left: sectionWannabeView.leftAnchor, bottom: sectionWannabeView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 0)
        
        _ = wannabeTableView.anchor(sectionWannabeView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func registerCells() {
        partnersTableView.register(FollowerCell.self, forCellReuseIdentifier: partnersCellId)
        wannabeTableView.register(FollowerCell.self, forCellReuseIdentifier: wannabeCellId)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == wannabeTableView {
            let acceptSubmissionViewController = AcceptSubmissionViewController()
            if let meetingId = self.meetingId {
                acceptSubmissionViewController.meetingId = meetingId
                acceptSubmissionViewController.wannabeUser = wannabe[indexPath.row]
                acceptSubmissionViewController.attachedViewController = self
            }
            
            navigationController?.pushViewController(acceptSubmissionViewController, animated: true)
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if partnersTableView == tableView {
            return partners.count
        } else {
            return wannabe.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == partnersTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: partnersCellId, for: indexPath) as! FollowerCell
            cell.isDark = true
            cell.userInfo = self.partners[indexPath.item]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: wannabeCellId, for: indexPath) as! FollowerCell
            cell.isDark = true
            cell.userInfo = self.wannabe[indexPath.item]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}


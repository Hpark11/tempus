//
//  AcceptSubmissionViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 21..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class AcceptSubmissionViewController: UIViewController {

    var attachedViewController: CommunityPartnersListViewController?
    var meetingId: String?
    var wannabeUser: Users? {
        didSet {
            if let wannabeUser = self.wannabeUser, let meetingId = self.meetingId {
                
                wannabeLabel.text = "가입신청인 : \(wannabeUser.username)"
                FirebaseDataService.instance.userRef.child(wannabeUser.uid).child(Constants.Users.submission).child(meetingId).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let data = snapshot.value as? Dictionary<String, AnyObject> {
                        self.uploadImageView.imageUrlString = data[Constants.Users.Submission.imageUrl] as? String
                        self.mainTextView.text = data[Constants.Users.Submission.introduction] as? String
                    }
                })
                
                FirebaseDataService.instance.meetingRef.child(meetingId).child(Constants.Meetings.frontImageUrl).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let imageUrl = snapshot.value as? String {
                        self.mainImageView.imageUrlString = imageUrl
                    }
                })
            }
        }
    }
    
    let logoLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 26))
        label.font = UIFont(name: "GothamRounded-Bold", size: 24)
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
        return label
    }()
    
    let mainImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder image")
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 가입신청서"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    let wannabeLabel: UILabel = {
        let label = UILabel()
        label.text = "가입신청인 : "
        label.textColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var uploadImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder image")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let reasonLabel: UILabel = {
        let label = UILabel()
        label.text = "자기소개"
        label.textColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var mainTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.isEditable = false
        textView.isScrollEnabled = true
        return textView
    }()
    
    lazy var acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.makeViaRgb(red: 0, green: 159, blue: 232)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        button.titleLabel?.text = "허가"
        button.setTitle("허가", for: .normal)
        return button
    }()
    
    func acceptButtonTapped() {
        if let wannabeUser = self.wannabeUser, let meetingId = self.meetingId {
            // 유저데이터의 submission의 데이터를 삭제한다
            let wannabeRef = FirebaseDataService.instance.meetingRef.child(meetingId).child(Constants.Meetings.wannabe)
            let partnersRef = FirebaseDataService.instance.meetingRef.child(meetingId).child(Constants.Meetings.partners)
            
            FirebaseDataService.instance.userRef.child(wannabeUser.uid).child(Constants.Users.submission).child(meetingId).removeValue()
            
            // 유저데이터의 appliedMeeting데이터를 추가시킨다

            var userMeetings = wannabeUser.appliedMeetings
            userMeetings.append(meetingId)
            
            FirebaseDataService.instance.userRef.child(wannabeUser.uid).child(Constants.Users.appliedMeetings).setValue(userMeetings)
            
            
            // 미팅데이터의 워너비 데이터를 지운다
            wannabeRef.observeSingleEvent(of: .value, with: { (snapshot) in
                var restore = Array<String>()
                if let wannabe = snapshot.value as? Array<String> {
                    for one in wannabe {
                        if one == wannabeUser.uid {
                            wannabeRef.child(one).removeValue()
                        } else {
                            restore.append(one)
                        }
                    }
                    wannabeRef.setValue(restore)
                }
            })
            
            partnersRef.observeSingleEvent(of: .value, with: { (snapshot) in
                var restore = Array<String>()
                if let partners = snapshot.value as? Array<String> {
                    restore = partners
                }
                restore.append(wannabeUser.uid)
                partnersRef.setValue(restore)
                
                if let attachedViewController = self.attachedViewController {
                    attachedViewController.getPartnersAndWannabe(meetingId: meetingId)
                }
                
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    lazy var rejectButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.red
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(rejectButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        button.titleLabel?.text = "거절"
        button.setTitle("거절", for: .normal)
        return button
    }()
    
    func rejectButtonTapped() {
        if let wannabeUser = self.wannabeUser, let meetingId = self.meetingId {
            let wannabeRef = FirebaseDataService.instance.meetingRef.child(meetingId).child(Constants.Meetings.wannabe)
            FirebaseDataService.instance.userRef.child(wannabeUser.uid).child(Constants.Users.submission).child(meetingId).removeValue()
            // 미팅데이터의 워너비 데이터를 지운다
            wannabeRef.observeSingleEvent(of: .value, with: { (snapshot) in
                var restore = Array<String>()
                if let wannabe = snapshot.value as? Array<String> {
                    for one in wannabe {
                        if one == wannabeUser.uid {
                            wannabeRef.child(one).removeValue()
                        } else {
                            restore.append(one)
                        }
                    }
                    wannabeRef.setValue(restore)
                }
                if let attachedViewController = self.attachedViewController {
                    attachedViewController.getPartnersAndWannabe(meetingId: meetingId)
                }
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubViews()
        setConstraints()
        
        navigationItem.titleView = logoLabel
        self.navigationItem.title = ""
    }
    
    fileprivate func addSubViews() {
        view.addSubview(mainImageView)
        view.addSubview(overlayView)
        view.addSubview(titleLabel)
        view.addSubview(wannabeLabel)
        view.addSubview(uploadImageView)
        view.addSubview(reasonLabel)
        view.addSubview(mainTextView)
        view.addSubview(acceptButton)
        view.addSubview(rejectButton)
    }
    
    fileprivate func setConstraints() {
        _ = mainImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = overlayView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = titleLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 44)
        
        _ = wannabeLabel.anchor(titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 20)
        
        _ = uploadImageView.anchor(wannabeLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: view.frame.height / 3.6)
        
        _ = reasonLabel.anchor(uploadImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 20)
        
        _ = rejectButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 54, rightConstant: 0, widthConstant: view.frame.width / 2 - 16 - 4, heightConstant: 36)
        
        _ = acceptButton.anchor(nil, left: rejectButton.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 54, rightConstant: 16, widthConstant: 0, heightConstant: 36)
        
        _ = mainTextView.anchor(reasonLabel.bottomAnchor, left: view.leftAnchor, bottom: acceptButton.topAnchor, right: view.rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
    }
    
    
}

//
//  CommunityMyListViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 20..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class CommunityMyListViewController: UITableViewController {

    let cellId = "cellId"

    var openedMeetings = [MinimizedMeeting]()
    
    func observeFirebaseValue() {
        openedMeetings.removeAll()
        if let userId = FIRAuth.auth()?.currentUser?.uid {
            FirebaseDataService.instance.userRef.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let user = snapshot.value as? Dictionary<String, AnyObject> {
                    let userInfo = Users(uid: snapshot.key, data: user)
                    for meetingId in userInfo.openedMeetings {
                        FirebaseDataService.instance.meetingRef.child(meetingId).observeSingleEvent(of: .value, with: { (snap) in
                            if let meeting = snap.value as? Dictionary<String, AnyObject> {
                                let minMeeting = MinimizedMeeting(id: snap.key, data: meeting)
                                self.openedMeetings.append(minMeeting)
                            }
                            DispatchQueue.main.async(execute: {
                                self.tableView.reloadData()
                            })
                        })
                    }
                }
            })
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 26))
        label.font = UIFont(name: "GothamRounded-Bold", size: 24)
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarUI()
        registerCells()
        tableView.backgroundColor = UIColor.makeViaRgb(red: 12, green: 12, blue: 12)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeFirebaseValue()
    }

    
    fileprivate func setNavigationBarUI() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon signout solid"), style: .plain, target: self, action: #selector(signOutButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon submit"), style: .plain, target: self, action: #selector(openNewMeeting))
        self.navigationItem.title = ""
    }
    
    func openNewMeeting() {
        if let _ = KeychainWrapper.standard.string(forKey: Constants.keychainUid) {
            let layout = UICollectionViewFlowLayout()
            let meetingAddViewController = MeetingAddViewController(collectionViewLayout: layout)
            navigationController?.pushViewController(meetingAddViewController, animated: true)
        }
    }
    
    fileprivate func registerCells() {
        tableView.register(SelfMadeMeetingListCell.self, forCellReuseIdentifier: cellId)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = KeychainWrapper.standard.string(forKey: Constants.keychainUid) {
            let communityPartnersListViewController = CommunityPartnersListViewController()
            communityPartnersListViewController.meetingId = openedMeetings[indexPath.item].id
            navigationController?.pushViewController(communityPartnersListViewController, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openedMeetings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SelfMadeMeetingListCell
        cell.meeting = self.openedMeetings[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

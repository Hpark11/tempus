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
import iCarousel

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
        
        tableView.backgroundColor = .white// UIColor.makeViaRgb(red: 12, green: 12, blue: 12)
        //carousel.type = .coverFlow
        //view.addSubview(carousel)
        //_ = carousel.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeFirebaseValue()
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
        if self.openedMeetings.count > indexPath.item {
            cell.meeting = self.openedMeetings[indexPath.item]
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
//    lazy var carousel: iCarousel = {
//        let carousel = iCarousel()
//        carousel.delegate = self
//        carousel.dataSource = self
//        carousel.isPagingEnabled = true
//        return carousel
//    }()
//    
//    func numberOfItems(in carousel: iCarousel) -> Int {
//        return openedMeetings.count
//    }
//    
//    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
//        var label: UILabel
//        var itemView: DownloadImageView
//        
//        //reuse view if available, otherwise create a new view
//        if let view = view as? DownloadImageView {
//            itemView = view
//            //get a reference to the label in the recycled view
//            label = itemView.viewWithTag(1) as! UILabel
//        } else {
//            //don't do anything specific to the index within
//            //this `if ... else` statement because the view will be
//            //recycled and used with other index values later
//            itemView = DownloadImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200 * 16 / 9))
//            itemView.image = UIImage(named: "placeholder image")
//            itemView.imageUrlString = openedMeetings[index].imageUrl
//            itemView.contentMode = .scaleAspectFill
//            itemView.clipsToBounds = true
//            itemView.layer.cornerRadius = 8
//            itemView.layer.masksToBounds = true
//            
//            label = UILabel(frame: itemView.bounds)
//            label.backgroundColor = .clear
//            label.textAlignment = .left
//            label.font = label.font.withSize(24)
//            label.tag = 1
//            itemView.addSubview(label)
//        }
//        
//        //set item label
//        //remember to always set any properties of your carousel item
//        //views outside of the `if (view == nil) {...}` check otherwise
//        //you'll get weird issues with carousel item content appearing
//        //in the wrong place in the carousel
//        label.text = openedMeetings[index].title
//        
//        return itemView
//    }
//    
//    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
//        if let _ = KeychainWrapper.standard.string(forKey: Constants.keychainUid) {
//            let communityPartnersListViewController = CommunityPartnersListViewController()
//            communityPartnersListViewController.meetingId = openedMeetings[index].id
//            navigationController?.pushViewController(communityPartnersListViewController, animated: true)
//        }
//    }
//    
//    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
//        if (option == .spacing) {
//            return value * 1.1
//        }
//        return value
//    }
//    
//    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
//        return 200
//    }
    
}

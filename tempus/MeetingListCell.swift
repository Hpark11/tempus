//
//  MeetingContentCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 9..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class MeetingListCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var attachedViewController: MeetingListViewController?
    var category: String? {
        didSet {
            if let category = category {
                observeFirebaseValue(category: category)
            }
        }
    }
    
    var collectionViewTopAnchor: NSLayoutConstraint?
    var collectionViewbottomAnchor: NSLayoutConstraint?
    
    var searchWord: String? {
        didSet {
            if let searchWord = searchWord {
                filteredMeetingList.removeAll()
                for meeting in meetingList {
                    if meeting.title?.range(of:searchWord) != nil || searchWord == "" {
                        filteredMeetingList.append(meeting)
                    }
                }
                collectionView.reloadData()
                //collectionViewTopAnchor?.constant = 108
            } else {
                collectionViewTopAnchor?.constant = 0
            }
            collectionViewbottomAnchor?.constant = frame.height
        }
    }
    
    var filteredMeetingList = [Meeting]()
    var meetingList = [Meeting]()
    func observeFirebaseValue(category: String) {
        let meetingRef = FirebaseDataService.instance.meetingRef
        
        meetingRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, AnyObject> {
                for (key, data) in dict {
                    if let value = data as? Dictionary<String, AnyObject> {
                        if category == value[Constants.Meetings.category] as? String {
                            if let userId = value[Constants.Meetings.userId] as? String {
                                FirebaseDataService.instance.userRef.child(userId).observeSingleEvent(of: .value, with: { (snapUser) in
                                    if let userInfo = snapUser.value as? Dictionary<String, AnyObject> {
                                        let meeting = Meeting(id:key, data: value, userInfo: userInfo)
                                        self.meetingList.append(meeting)
                                        if let word = self.searchWord, (meeting.title?.range(of:word) != nil) || (word == "") {
                                            self.filteredMeetingList.append(meeting)
                                        } else {
                                            self.filteredMeetingList.append(meeting)
                                        }
                                    }
                                    DispatchQueue.main.async(execute: {
                                        self.collectionView.reloadData()
                                    })
                                })
                            }
                        }
                    }
                }
            }
        })
    }
    
    let cellId = "cellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubViews()
        setConstraints()
        registerCells()
        setupKeyboardObservers()
    }
    
    fileprivate func addSubViews() {
        addSubview(collectionView)
    }
    
    
    fileprivate func setConstraints() {
        let anchors = collectionView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.height)
        
        collectionViewTopAnchor = anchors[0]
        collectionViewbottomAnchor = anchors[3]
    }
    
    fileprivate func registerCells() {
        collectionView.register(MeetingCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let attachedViewController = self.attachedViewController {
            if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
                attachedViewController.setTabBarVisibility(isHidden: true, animated: true)
            } else {
                attachedViewController.setTabBarVisibility(isHidden: false, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMeetingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MeetingCell
        if let attachedViewController = self.attachedViewController {
            cell.attachedViewController = attachedViewController
            cell.meeting = filteredMeetingList[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (frame.width - 2 * Constants.sizeStandards.spaceShort) * Constants.sizeStandards.landscapeRatio
        return CGSize(width: frame.width, height: height + 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShow(notification: Notification) {
        _ = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        //collectionViewTopAnchor?.constant = 108
        //collectionViewbottomAnchor?.constant = -(keyboardSize.cgRectValue.height)
        UIView.animate(withDuration: keyboardDuration) {
            self.collectionView.layoutIfNeeded()
        }
    }
    
    func handleKeyboardWillHide(notification: Notification) {
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        //collectionViewbottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration) {
            self.collectionView.layoutIfNeeded()
        }
    }
}

//
//  ViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 8..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase


class MeetingListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var selfImprovementMeetings = [Meeting]()
    var prepareExaminationMeetings = [Meeting]()
    var professionalSkillsMeetings = [Meeting]()
    var lookingForHobbyMeetings = [Meeting]()
    
    struct MeetingListData {
        static let selfImprovementCellId = "selfImprovementCellId"
        static let prepareExaminationCellId = "prepareExaminationCellId"
        static let professionalSkillsCellId = "professionalSkillsCellId"
        static let lookingForHobbyCellId = "lookingForHobbyCellId"
        static let cells = [selfImprovementCellId, prepareExaminationCellId, professionalSkillsCellId, lookingForHobbyCellId]
        
        static let categoryBarSize: CGFloat = 50.0
    }
    
    /*
     *  UI Components
     */
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon search"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var addMeetingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon add meeting"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        button.addTarget(self, action: #selector(addMeetingButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var categoryBarView: CategoryBarView = {
        let categoryBarView = CategoryBarView()
        categoryBarView.attachedViewController = self
        return categoryBarView
    }()
    
    func searchButtonTapped() {
    }
    
    func addMeetingButtonTapped() {
        let layout = UICollectionViewFlowLayout()
        let meetingAddViewController = MeetingAddViewController(collectionViewLayout: layout)
        //navigationController?.pushViewController(meetingAddViewController, animated: true)
        
        present(meetingAddViewController, animated: true, completion: nil)
        
    }
    
    func scrollToCategoryIndex(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarUI()
        setCollectionViewUI()
        addSubViews()
        setConstraints()
        registerCells()
        
        collectionView?.backgroundColor = UIColor.white
        observeFirebaseValue()
    }
    
    func observeFirebaseValue() {
        // get list of memePosts from Firebase
        FirebaseDataService.instance.meetingRef.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.selfImprovementMeetings.removeAll()
//                self.prepareExaminationMeetings.removeAll()
//                self.professionalSkillsMeetings.removeAll()
//                self.lookingForHobbyMeetings.removeAll()
                
                for one in snapshot {
                    if let postMeeting = one.value as? Dictionary<String, AnyObject> {
                        FirebaseDataService.instance.userRef.child(postMeeting[Constants.Meetings.userId] as! String).observeSingleEvent(of: .value, with: { (userSnap) in
                            if let userInfo = userSnap.value as? Dictionary<String, AnyObject> {
                                let meeting = Meeting(data: postMeeting, username: userInfo[Constants.Users.username] as! String, numFollowers: userInfo[Constants.Users.numFollowers] as! Int, numComments: userInfo[Constants.Users.numComments] as! Int)
                                self.selfImprovementMeetings.append(meeting)
                                
                                print(meeting)
                            }
                        })
                    }
                }
            }
            
//            self.selfImprovementMeetings.reverse()
//            self.prepareExaminationMeetings.reverse()
//            self.professionalSkillsMeetings.reverse()
//            self.lookingForHobbyMeetings.reverse()
//            
//            self.collectionView?.reloadData()
        })
    }
    
    
    fileprivate func setNavigationBarUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        
        navigationItem.titleView = titleLabel
        let searchButtonItem = UIBarButtonItem(customView: searchButton)
        let addMeetingButtonItem = UIBarButtonItem(customView: addMeetingButton)
        self.navigationItem.rightBarButtonItems = [addMeetingButtonItem, searchButtonItem]
    }
    
    fileprivate func setCollectionViewUI() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.isPagingEnabled = true
    }
    
    fileprivate func addSubViews() {
        self.view.addSubview(categoryBarView)
    }
    
    fileprivate func setConstraints() {
        _ = categoryBarView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: MeetingListData.categoryBarSize)
        
        _ = collectionView?.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: MeetingListData.categoryBarSize, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func registerCells() {
        collectionView?.register(MeetingListCell.self, forCellWithReuseIdentifier: MeetingListData.selfImprovementCellId)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        categoryBarView.categoryHighlightedBarConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        categoryBarView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MeetingListData.cells.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingListData.selfImprovementCellId, for: indexPath) as! MeetingListCell
        cell.attachedViewController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - MeetingListData.categoryBarSize)
    }
}


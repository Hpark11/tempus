//
//  MeetingViewBottomPanelCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 8..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MeetingViewBottomPanelCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    var attachedViewController: MeetingViewController?
    var meetings = [MinimizedMeeting]()
    
    
    var content: MeetingBottomPanelContent? {
        didSet {
            if let content = content {
                meetingTypeLabel.text = content.categoryName
                moreButton.tag = content.tag
                setMeetings(category: content.category)
            }
        }
    }
    
    struct MeetingViewCellData {
        static let cellId = "cellId"
    }
    
    func setMeetings(category: String) {
        for meeting in rawMeetingList {
            let one = MinimizedMeeting(id: meeting[Constants.Meetings.userId] as! String, data: meeting)
            if category == one.categoryEn {
                meetings.append(one)
            }
        }
    }
    
    /*
     *  UI Components
     */
    let meetingTypeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        label.text = "카운셀링"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        //button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var meetingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .blue
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.keyboardDismissMode = .interactive
        return collectionView
    }()
    
    /*
     *  UI Actions
     */
    func moreButtonTapped() {
        //let controller = MeetingListViewController()
        
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        self.contentView.isUserInteractionEnabled = false
        
        addSubViews()
        setConstraints()
        registerCells()
    }
    
    fileprivate func addSubViews() {
        addSubview(meetingTypeLabel)
        addSubview(moreButton)
        addSubview(meetingCollectionView)
    }
    
    fileprivate func setConstraints() {
        _ = meetingTypeLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 32)
        
        _ = moreButton.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 60, heightConstant: 32)
        
        _ = meetingCollectionView.anchor(meetingTypeLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func registerCells() {
        meetingCollectionView.register(RecommendedMeetingViewCell.self, forCellWithReuseIdentifier: MeetingViewCellData.cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meetings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let attachedViewController = self.attachedViewController {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let slideViewController = SlideViewController(collectionViewLayout: layout)
            slideViewController.meetingId = self.meetings[indexPath.item].id
            slideViewController.meetingMainImageUrl = self.meetings[indexPath.item].imageUrl
            attachedViewController.present(slideViewController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingViewCellData.cellId, for: indexPath) as! RecommendedMeetingViewCell
        cell.meeting = meetings[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: meetingCollectionView.frame.height)
    }

}

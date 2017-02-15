//
//  MeetingContentCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 9..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MeetingListCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var attachedViewController: MeetingListViewController?
    var meetingList: [Meeting]? {
        didSet {
            collectionView.reloadData()
        }
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
    }
    
    fileprivate func addSubViews() {
        addSubview(collectionView)
    }
    
    fileprivate func setConstraints() {
        _ = collectionView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
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
        return meetingList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MeetingCell
        if let attachedViewController = self.attachedViewController {
            cell.attachedViewController = attachedViewController
            cell.meeting = meetingList?[indexPath.item]
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
}

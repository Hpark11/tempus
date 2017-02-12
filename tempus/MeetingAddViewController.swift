//
//  MeetingAddViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 12..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MeetingAddViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    struct MeetingAddViewData {
        static let coverCellId = "coverCellId"
        static let cellId = "cellId"
        static let detailId = "detailId"
        
        static let cellIds = [coverCellId, cellId, detailId]
    }
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        label.textAlignment = .center
        label.text = "게시하기"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = .white
        addSubViews()
        setNavigationBarUI()
        registerCells()
    }
    
    fileprivate func addSubViews() {
    
    }
    
    fileprivate func setNavigationBarUI() {
        navigationItem.titleView = titleLabel
    }
    
    fileprivate func setConstraints() {
        _ = collectionView?.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func registerCells() {
        collectionView?.register(MeetingAddCoverCell.self, forCellWithReuseIdentifier: MeetingAddViewData.coverCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MeetingAddViewData.cellIds.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: MeetingAddViewData.coverCellId, for: indexPath) as! MeetingAddCoverCell
//        if indexPath.item == 0 {
//            return collectionView.dequeueReusableCell(withReuseIdentifier: SlideViewData.coverCellId, for: indexPath) as! SlideCoverCell
//        } else if indexPath.item == 4 {
//            return collectionView.dequeueReusableCell(withReuseIdentifier: SlideViewData.detailId, for: indexPath) as! SlideDetailCell
//        } else {
//            return collectionView.dequeueReusableCell(withReuseIdentifier: SlideViewData.cellId, for: indexPath) as! SlideCell
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width * Constants.sizeStandards.landscapeRatio)
    }
}

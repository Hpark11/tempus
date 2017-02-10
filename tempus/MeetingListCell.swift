//
//  MeetingContentCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 9..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MeetingListCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
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

//import UIKit
//
//class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    
//    lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = UIColor.white
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        return collectionView
//    }()
//    
//    var videos: [Video]?
//    let cellId = "cellId"
//    
//    func fetchVideos() {
//        ApiService.sharedInstance.fetchVideos { (videos: [Video]) in
//            self.videos = videos
//            self.collectionView.reloadData()
//        }
//    }
//    
//    override func setupViews() {
//        super.setupViews()
//        
//        fetchVideos()
//        
//        addSubview(collectionView)
//        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
//        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
//        
//        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellId)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return videos?.count ?? 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
//        cell.video = videos?[indexPath.item]
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height = (frame.width - 16 - 16) * 9 / 16
//        return CGSize(width: frame.width, height: height + 16 + 88)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//    
//}


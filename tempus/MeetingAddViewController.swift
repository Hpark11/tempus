//
//  MeetingAddViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 12..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MeetingAddViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var mainImage: UIImage?
    var subImages: [UIImage] = [UIImage(named: "placeholder1")!]
    var detailImage: UIImage?
    var imgTag: Int = 0
    var numStories: Int = 1
    var submitData: SubmitData = SubmitData()
    
    struct MeetingAddViewData {
        static let coverCellId = "coverCellId"
        static let cellId = "cellId"
        static let detailId = "detailId"
        
        static let cellIds = [coverCellId, cellId, detailId]
    }
    
    struct SubmitData {
        var position: Position = Position()
    
        struct Position {
            // Coordinate of Seoul, South Korea
            var address: String = "대한민국 서울"
            var latitude: Double = 37.6183087
            var longitude: Double = 126.9390451
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        label.textAlignment = .center
        label.text = "게시하기"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = .white
        addSubViews()
        setConstraints()
        registerCells()
        setCollectionViewUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    fileprivate func setCollectionViewUI() {
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0)
        collectionView?.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
    }
    
    fileprivate func addSubViews() {
        view.addSubview(headerView)
    }
    
    fileprivate func setConstraints() {
        _ = headerView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 64)
        
        _ = collectionView?.anchor(headerView.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func registerCells() {
        collectionView?.register(MeetingAddCoverCell.self, forCellWithReuseIdentifier: MeetingAddViewData.coverCellId)
        collectionView?.register(MeetingAddDetailCell.self, forCellWithReuseIdentifier: MeetingAddViewData.detailId)
        collectionView?.register(MeetingAddCell.self, forCellWithReuseIdentifier: MeetingAddViewData.cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numStories + 2 // 2 is for Cover and Detail Cell
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let coverCell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingAddViewData.coverCellId, for: indexPath) as! MeetingAddCoverCell
            if let mainImage = self.mainImage {
                coverCell.mainImageView.image = mainImage
            }
            coverCell.attachedViewController = self
            return coverCell
        } else if indexPath.item == 1 {
            let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingAddViewData.detailId, for: indexPath) as! MeetingAddDetailCell
            if let detailImage = self.detailImage {
                detailCell.detailImageView.image = detailImage
            }
            detailCell.traceSavedLocation(latitude: submitData.position.latitude, longitude: submitData.position.longitude, address: submitData.position.address)
            detailCell.attachedViewController = self
            return detailCell
        } else {
            let storyCell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingAddViewData.cellId, for: indexPath) as! MeetingAddCell
            if indexPath.item >= 2 {
                storyCell.cellImageView.image = subImages[indexPath.item - 2]
                storyCell.imgTag = indexPath.item
                
                var isFirst: Bool = false
                var isLast: Bool = false
                if indexPath.item == 2 {
                    isFirst = true
                }
                if (indexPath.item - 1) == subImages.count {
                    isLast = true
                }
                
                storyCell.resetMeetingCell(isFirst: isFirst, isLast: isLast)
                storyCell.attachedViewController = self
            }
            return storyCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: view.frame.width, height: view.frame.width * Constants.sizeStandards.landscapeRatio)
        } else if indexPath.item == 1 {
            return CGSize(width: view.frame.width, height: view.frame.width * Constants.sizeStandards.landscapeRatio * 2.4)
        } else if (indexPath.item - 1) == subImages.count {
            return CGSize(width: view.frame.width, height: view.frame.width * Constants.sizeStandards.landscapeRatio + 50)
        } else {
            return CGSize(width: view.frame.width, height: view.frame.width * Constants.sizeStandards.landscapeRatio)
        }
    }
}

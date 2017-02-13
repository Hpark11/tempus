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
    var subImages: [UIImage] = []
    var detailImage: UIImage?
    var imgTag: Int = 0
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
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MeetingAddViewData.cellIds.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let coverCell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingAddViewData.coverCellId, for: indexPath) as! MeetingAddCoverCell
            if let mainImage = self.mainImage {
                coverCell.mainImageView.image = mainImage
            }
            coverCell.attachedViewController = self
            return coverCell
        } else {
            let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingAddViewData.detailId, for: indexPath) as! MeetingAddDetailCell
            if let detailImage = self.detailImage {
                detailCell.detailImageView.image = detailImage
            }
            detailCell.attachedViewController = self
            return detailCell
        }
        
        
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
        if indexPath.item == 0 {
            return CGSize(width: view.frame.width, height: view.frame.width * Constants.sizeStandards.landscapeRatio)
        } else {
            return CGSize(width: view.frame.width, height: view.frame.width * Constants.sizeStandards.landscapeRatio * 2.4)
        }
    }
}

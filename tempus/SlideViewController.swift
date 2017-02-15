//
//  SlideViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 11..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class SlideViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{

    var beforeButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    
    struct SlideViewData {
        static let coverCellId = "coverCellId"
        static let cellId = "cellId"
        static let detailId = "detailId"
    }
    
    lazy var beforeButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "before") {
            button.setImage(image, for: .normal)
        }
        //button.addTarget(self, action: #selector(beforeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "next") {
            button.setImage(image, for: .normal)
        }
        //button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        
        collectionView?.isPagingEnabled = true
        
        addSubViews()
        setConstraints()
        registerCells()
    }
    
    fileprivate func addSubViews() {
        navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func setConstraints() {
        _ = collectionView?.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        beforeButtonTopAnchor = beforeButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 40).first
        
        nextButtonTopAnchor = nextButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 40).first
    }
    
    fileprivate func registerCells() {
        self.collectionView?.register(SlideCoverCell.self, forCellWithReuseIdentifier: SlideViewData.coverCellId)
        self.collectionView?.register(SlideCell.self, forCellWithReuseIdentifier: SlideViewData.cellId)
        self.collectionView?.register(SlideDetailCell.self, forCellWithReuseIdentifier: SlideViewData.detailId)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: SlideViewData.coverCellId, for: indexPath) as! SlideCoverCell
        } else if indexPath.item == 4 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: SlideViewData.detailId, for: indexPath) as! SlideDetailCell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: SlideViewData.cellId, for: indexPath) as! SlideCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.frame.height)
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

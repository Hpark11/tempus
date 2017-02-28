//
//  SlideViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 11..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class SlideViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{

    var beforeButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    
    var meetingId: String? {
        didSet {
            if let id = meetingId {
                getSlides(id: id)
            }
        }
    }
    var slides = [String]()
    var meetingMainImageUrl: String? {
        didSet {
            if let imageUrl = meetingMainImageUrl {
                mainImageView.imageUrlString = imageUrl
            }
        }
    }
    
    struct SlideViewData {
        static let coverCellId = "coverCellId"
        static let cellId = "cellId"
        static let detailId = "detailId"
    }
    
    let mainImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var beforeButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "icon cancel") {
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(beforeButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
//    lazy var nextButton: UIButton = {
//        let button = UIButton()
//        if let image = UIImage(named: "next") {
//            button.setImage(image, for: .normal)
//        }
//        //button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
//        return button
//    }()
    
    func beforeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = UIColor.clear
    
        addSubViews()
        setConstraints()
        registerCells()
    }
    
    fileprivate func getSlides(id: String) {
        self.slides.removeAll()
        FirebaseDataService.instance.meetingRef.child(id).child(Constants.Meetings.slides).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for one in snapshot {
                    self.slides.append(one.key)
                }
            }
            self.collectionView?.reloadData()
        })
    }
    
    fileprivate func addSubViews() {
        navigationController?.navigationBar.isHidden = true
        collectionView?.backgroundView = mainImageView
        view.addSubview(beforeButton)
        //view.addSubview(nextButton)
    }
    
    fileprivate func setConstraints() {
        _ = collectionView?.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        beforeButtonTopAnchor = beforeButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 40).first
        
        //nextButtonTopAnchor = nextButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 40).first
    }
    
    fileprivate func registerCells() {
        self.collectionView?.register(SlideCoverCell.self, forCellWithReuseIdentifier: SlideViewData.coverCellId)
        self.collectionView?.register(SlideCell.self, forCellWithReuseIdentifier: SlideViewData.cellId)
        self.collectionView?.register(SlideDetailCell.self, forCellWithReuseIdentifier: SlideViewData.detailId)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (slides.count + 2)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideViewData.coverCellId, for: indexPath) as! SlideCoverCell
            cell.meetingId = self.meetingId
            return cell
        } else if indexPath.item == (slides.count + 1) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideViewData.detailId, for: indexPath) as! SlideDetailCell
            cell.attachedViewController = self
            cell.meetingId = self.meetingId
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideViewData.cellId, for: indexPath) as! SlideCell
            cell.meetingId = self.meetingId
            cell.slideId = slides[indexPath.item - 1]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  view.frame.width, height: view.frame.height)
    }
}

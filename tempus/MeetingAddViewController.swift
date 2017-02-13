//
//  MeetingAddViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 12..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

struct Cover {
    var title: String?
    var subTitle: String?
}

struct Detail {
    var price: String?
    var preferred: String?
    var profile: String?
}

struct Normal {
    var storyTitle: String = ""
    var storySubtitle: String = ""
    var storyTitleCharNumber: Int = 0
    var storySubtitleCharNumber: Int = 0
}

struct Position {
    // Coordinate of Seoul, South Korea
    var address: String = "대한민국 서울"
    var latitude: Double = 37.6183087
    var longitude: Double = 126.9390451
}

class MeetingAddViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var mainImage: UIImage?
    var subImages: [UIImage] = [UIImage()]
    var detailImage: UIImage?
    
    var imgTag: Int = 0
    var numStories: Int = 1
    var dataIterator: Int = 0
    
    var submitData: SubmitData = SubmitData()
    
    enum CellType : String {
        case cover = "cover"
        case detail = "detail"
        case normal = "normal"
    }
    
    struct MeetingAddViewData {
        static let coverCellId = "coverCellId"
        static let cellId = "cellId"
        static let detailId = "detailId"
        static let cellIds = [coverCellId, cellId, detailId]
    }
    
    struct SubmitData {
        var isPassed: Bool = false
        var cover: Cover = Cover()
        var detail: Detail = Detail()
        var normal: [Normal] = [Normal()]
        var position: Position = Position()
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
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.setTitle("게시하기", for: .normal)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    
    
    lazy var alertController: UIAlertController = {
        let alert = UIAlertController(title: "스토리 게시", message: "정말 게시하겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
            let firebaseAutoRef = FirebaseDataService.instance.meetingRef.childByAutoId()
            let firebaseRefPosition = firebaseAutoRef.child(Constants.Meetings.position)
            
            firebaseAutoRef.setValue([Constants.Meetings.dateTime: NSNumber(value: Int(Date().timeIntervalSince1970))])
            firebaseRefPosition.setValue([
                Constants.Meetings.Position.address: self.submitData.position.address,
                Constants.Meetings.Position.latitude: NSNumber(value: self.submitData.position.latitude),
                Constants.Meetings.Position.longitude: NSNumber(value: self.submitData.position.longitude)
                ])
            
            self.imageToFirebaseStorage(image: self.mainImage, cellType: .cover, dataReference: firebaseAutoRef)
            self.imageToFirebaseStorage(image: self.detailImage, cellType: .detail, dataReference: firebaseAutoRef)
            for image in self.subImages {
                self.imageToFirebaseStorage(image: image, cellType: .normal, dataReference: firebaseAutoRef)
            }
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .default) { action in })
        return alert
    }()
    
    lazy var beforeButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "before") {
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(beforeButtonTapped), for: .touchUpInside)
        return button
    }()

    func beforeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func submitButtonTapped() {
        present(alertController, animated: true, completion: nil)
    }
    
    func postDataToFirebase() {
        let firebaseAutoRef = FirebaseDataService.instance.meetingRef.childByAutoId()
        let firebaseRefPosition = firebaseAutoRef.child(Constants.Meetings.position)
        
        firebaseAutoRef.setValue([Constants.Meetings.dateTime: NSNumber(value: Int(Date().timeIntervalSince1970))])
        firebaseRefPosition.setValue([
            Constants.Meetings.Position.address: self.submitData.position.address,
            Constants.Meetings.Position.latitude: NSNumber(value: self.submitData.position.latitude),
            Constants.Meetings.Position.longitude: NSNumber(value: self.submitData.position.longitude)
        ])
        
        self.imageToFirebaseStorage(image: self.mainImage, cellType: .cover, dataReference: firebaseAutoRef)
        self.imageToFirebaseStorage(image: self.detailImage, cellType: .detail, dataReference: firebaseAutoRef)
        for image in self.subImages {
            self.imageToFirebaseStorage(image: image, cellType: .normal, dataReference: firebaseAutoRef)
        }
    }
    
    func imageToFirebaseStorage(image: UIImage?, cellType: CellType, dataReference: FIRDatabaseReference) {
        if let image = image, let imageData = UIImageJPEGRepresentation(image, 1.0) {
            let imageUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            FirebaseDataService.instance.imageRef.child(imageUid).put(imageData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print(":::[HPARK] Unable to upload image to storage \(error as Any):::\n ")
                } else {
                    if let downloadURL = metadata?.downloadURL()?.absoluteString {
                        self.dataToFirebaseDatabase(imageUrl: downloadURL, cellType: cellType, dataReference: dataReference)
                    }
                }
            }
        }
    }
    
    func dataToFirebaseDatabase(imageUrl: String, cellType: CellType, dataReference: FIRDatabaseReference) {
        
        var dict: Dictionary<String, AnyObject>?
        var firebaseRef: FIRDatabaseReference?
        firebaseRef = dataReference.child(cellType.rawValue)
        
        if cellType == .cover {
            if let title = self.submitData.cover.title, let subTitle = self.submitData.cover.subTitle {
                dict = [
                    Constants.Meetings.Cover.title : title as AnyObject,
                    Constants.Meetings.Cover.subTitle : subTitle as AnyObject,
                    Constants.Meetings.Cover.imageUrl : imageUrl as AnyObject
                ]
            }
        } else if cellType == .detail {
            if let price = self.submitData.detail.price,
                let profile = self.submitData.detail.profile,
                let preferred = self.submitData.detail.preferred {
                dict = [
                    Constants.Meetings.Detail.price : price as AnyObject,
                    Constants.Meetings.Detail.profile : profile as AnyObject,
                    Constants.Meetings.Detail.preferred : preferred as AnyObject,
                    Constants.Meetings.Detail.imageUrl : imageUrl as AnyObject,
                ]
            }
        } else {
            dict = [
                Constants.Meetings.Normal.storyTitle : self.submitData.normal[dataIterator].storyTitle as AnyObject,
                Constants.Meetings.Normal.storySubtitle : self.submitData.normal[dataIterator].storySubtitle as AnyObject,
                Constants.Meetings.Normal.imageUrl : imageUrl as AnyObject
            ]
            dataIterator += 1
            if dataIterator >= self.submitData.normal.count {
                dataIterator = 0
            }
            //self.submitData.normal.removeLast()
            firebaseRef = firebaseRef?.childByAutoId()
        }
        
        firebaseRef?.setValue(dict)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
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
        view.addSubview(submitButton)
        view.addSubview(beforeButton)
    }
    
    fileprivate func setConstraints() {
        _ = headerView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 64)
        
        _ = collectionView?.anchor(headerView.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 64, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = submitButton.anchor(collectionView?.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        _ = beforeButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 40).first
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
                
                storyCell.storySubtitle = submitData.normal[indexPath.item - 2].storySubtitle
                storyCell.storyTitle = submitData.normal[indexPath.item - 2].storyTitle
                storyCell.storyTitleCharNumber = submitData.normal[indexPath.item - 2].storyTitleCharNumber
                storyCell.storySubtitleCharNumber = submitData.normal[indexPath.item - 2].storySubtitleCharNumber
                
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

//
//  MeetingAddViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 12..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

struct Slides {
    var storyTitle: String = ""
    var storySubtitle: String = ""
    var storyTitleCharNumber: Int = 0
    var storySubtitleCharNumber: Int = 0
}

class MeetingAddViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var mainImage: UIImage?
    var subImages = [UIImage]()
    var detailImage: UIImage?
    
    var imgTag: Int = 0
    var numStories: Int = 1
    var dataIterator: Int = 0
    
    var submitData: SubmitData = SubmitData()
    
    enum CellType : String {
        case cover = "cover"
        case detail = "detail"
        case slides = "slides"
    }
    
    struct MeetingAddViewData {
        static let coverCellId = "coverCellId"
        static let cellId = "cellId"
        static let detailId = "detailId"
        static let cellIds = [coverCellId, cellId, detailId]
    }
    
    struct SubmitData {
        var uid: String = KeychainWrapper.standard.string(forKey: Constants.keychainUid)!
        var title: String = ""
        var subTitle: String = ""
        var category: String = Constants.Category.selfImprovement
        var type: String = Constants.MeetingType.counseling
        var userId: String = ""
        
        var price: String = "0"
        var preferred: String = ""
        var profile: String = ""
        
        var address: String = "대한민국 서울"
        var latitude: Double = 37.6183087
        var longitude: Double = 126.9390451
        
        var isPassed: Bool = false
        var slides: [Slides] = [Slides()]
    }
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        label.textAlignment = .center
        label.text = "새로운 모임 개설"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.makeViaRgb(red: 80, green: 227, blue: 194)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        button.titleLabel?.text = "게시하기"
        button.setTitle("게시하기", for: .normal)
        return button
    }()
    
    
    
    
    lazy var alertController: UIAlertController = {
        let alert = UIAlertController(title: "스토리 게시", message: "정말 게시하겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
            
            let firebaseAutoRef = FirebaseDataService.instance.meetingRef.childByAutoId()
            
            
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                FirebaseDataService.instance.userRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let data = snapshot.value as? Dictionary<String, AnyObject> {
                        let user = Users(uid: snapshot.key, data: data)
                        var meetings = Array<String>()
                        for meeting in user.openedMeetings {
                            meetings.append(meeting)
                        }
                        meetings.append(firebaseAutoRef.key)
                        FirebaseDataService.instance.userRef.child(uid).updateChildValues([
                            Constants.Users.openedMeetings: meetings as NSArray
                        ])
                    }
                })
            }
            
            firebaseAutoRef.setValue([
                Constants.Meetings.dateTime: NSNumber(value: Int(Date().timeIntervalSince1970)),
                Constants.Meetings.address: self.submitData.address,
                Constants.Meetings.latitude: self.submitData.latitude,
                Constants.Meetings.longitude: self.submitData.longitude,
                Constants.Meetings.userId: self.submitData.uid,
                Constants.Meetings.isPassed: self.submitData.isPassed,
                Constants.Meetings.category: self.submitData.category,
                Constants.Meetings.type: self.submitData.type
            ])
            
            self.imageToFirebaseStorage(image: self.mainImage, cellType: .cover, dataReference: firebaseAutoRef)
            self.imageToFirebaseStorage(image: self.detailImage, cellType: .detail, dataReference: firebaseAutoRef)
            for image in self.subImages {
                self.imageToFirebaseStorage(image: image, cellType: .slides, dataReference: firebaseAutoRef)
            }
            _ = self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .default) { action in })
        return alert
    }()
    
    func submitButtonTapped() {
        
        present(alertController, animated: true, completion: nil)
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
                        FirebaseDataService.instance.imageUrlRef.childByAutoId().setValue(downloadURL)
                        self.dataToFirebaseDatabase(imageUrl: downloadURL, cellType: cellType, dataReference: dataReference)
                    }
                }
            }
        }
    }
    
    func dataToFirebaseDatabase(imageUrl: String, cellType: CellType, dataReference: FIRDatabaseReference) {
        
        var dict: Dictionary<String, AnyObject>?
        var firebaseRef: FIRDatabaseReference?
        firebaseRef = dataReference
        
        if cellType == .cover {
            firebaseRef?.child(Constants.Meetings.title).setValue(self.submitData.title as AnyObject)
            firebaseRef?.child(Constants.Meetings.subTitle).setValue(self.submitData.subTitle as AnyObject)
            firebaseRef?.child(Constants.Meetings.frontImageUrl).setValue(imageUrl as AnyObject)
            firebaseRef?.child(Constants.Meetings.profile).setValue(self.submitData.profile as AnyObject)
            firebaseRef?.child(Constants.Meetings.preferred).setValue(self.submitData.preferred as AnyObject)
            
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                let groupRef = FirebaseDataService.instance.groupRef.childByAutoId()
                groupRef.child(Constants.Group.imageUrl).setValue(imageUrl)
                groupRef.child(Constants.Group.name).setValue(self.submitData.title)
                FirebaseDataService.instance.userRef.child(uid).child(Constants.Users.group).child(groupRef.key).setValue(1)
                firebaseRef?.child(Constants.Meetings.group).setValue(groupRef.key)
            }
            
        } else if cellType == .detail {
            firebaseRef?.child(Constants.Meetings.profile).setValue(self.submitData.profile as AnyObject)
            firebaseRef?.child(Constants.Meetings.preferred).setValue(self.submitData.preferred as AnyObject)
        } else {
            dict = [
                Constants.Meetings.Slides.storyTitle : self.submitData.slides[dataIterator].storyTitle as AnyObject,
                Constants.Meetings.Slides.storySubtitle : self.submitData.slides[dataIterator].storySubtitle as AnyObject,
                Constants.Meetings.Slides.imageUrl : imageUrl as AnyObject
            ]
            dataIterator += 1
            if dataIterator >= self.submitData.slides.count {
                dataIterator = 0
            }
            firebaseRef = firebaseRef?.child(cellType.rawValue).childByAutoId()
            if let dict = dict {
                firebaseRef?.setValue(dict)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.collectionView?.backgroundColor = .white
        addSubViews()
        setConstraints()
        registerCells()
        setCollectionViewUI()
        setNavigationBarUI()
        subImages.append(UIImage(named: "placeholder image")!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    fileprivate func setNavigationBarUI() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.titleView = titleLabel
    }
    
    fileprivate func setCollectionViewUI() {
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -50, 0)
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, -50, 0)
    }
    
    fileprivate func addSubViews() {
        view.addSubview(submitButton)
    }
    
    fileprivate func setConstraints() {

        _ = submitButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 60, rightConstant: 16, widthConstant: 0, heightConstant: 38)
        
        _ = collectionView?.anchor(view.topAnchor, left: view.leftAnchor, bottom: submitButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)
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
            detailCell.traceSavedLocation(latitude: submitData.latitude, longitude: submitData.longitude, address: submitData.address)
            detailCell.attachedViewController = self
            return detailCell
        } else {
            let storyCell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingAddViewData.cellId, for: indexPath) as! MeetingAddCell
            if indexPath.item >= 2 {
                storyCell.cellImageView.image = subImages[indexPath.item - 2]
                storyCell.imgTag = indexPath.item
                
                storyCell.storySubtitle = submitData.slides[indexPath.item - 2].storySubtitle
                storyCell.storyTitle = submitData.slides[indexPath.item - 2].storyTitle
                storyCell.storyTitleCharNumber = submitData.slides[indexPath.item - 2].storyTitleCharNumber
                storyCell.storySubtitleCharNumber = submitData.slides[indexPath.item - 2].storySubtitleCharNumber
                
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
            return CGSize(width: view.frame.width, height: view.frame.width * Constants.sizeStandards.landscapeRatio * 3.4)
        } else if indexPath.item == 1 {
            return CGSize(width: view.frame.width, height: view.frame.width * Constants.sizeStandards.landscapeRatio * 2.8)
        } else if (indexPath.item - 1) == subImages.count {
            return CGSize(width: view.frame.width, height: view.frame.width * Constants.sizeStandards.landscapeRatio + 50)
        } else {
            return CGSize(width: view.frame.width, height: view.frame.width * Constants.sizeStandards.landscapeRatio)
        }
    }
}

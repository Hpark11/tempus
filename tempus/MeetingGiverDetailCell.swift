//
//  MeetingGiverDetailCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 16..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

class MeetingGiverDetailCell: BaseCell {
    
    var attachedViewController: SlideViewController?
    var meetingId: String? {
        didSet {
            observeFirebaseValue()
        }
    }
    
    
    
    func observeFirebaseValue() {
        if let id = self.meetingId {
            FirebaseDataService.instance.meetingRef.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? Dictionary<String, AnyObject> {
                    self.profileTextView.text = value[Constants.Meetings.profile] as? String
                    self.preferredTextView.text = value[Constants.Meetings.preferred] as? String
                    self.locationTextView.text = value[Constants.Meetings.address] as? String
                    
                    if let lat = value[Constants.Meetings.latitude] as? Double, let lng = value[Constants.Meetings.longitude] as? Double, let address = value[Constants.Meetings.address] as? String {
                        DispatchQueue.main.async(execute: { 
                            self.showSavedLocation(lat: lat, lng: lng, address:address)
                        })
                    }
                }
            })
        }
    }
    
    lazy var googlemapView: GMSMapView = {
        let view = GMSMapView()
        
        //view.settings.scrollGestures = false
        return view
    }()
    
    let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "내가 걸어온 길"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    lazy var profileTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsetsMake(0, 8, 0, 0)
        textView.textColor = .darkGray
        textView.backgroundColor = .white
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        textView.text = "이것은 테스트 문자열입니다"
        return textView
    }()

    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "선호하는 위치"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    lazy var locationTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsetsMake(0, 8, 0, 0)
        textView.textColor = .darkGray
        textView.backgroundColor = .white
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        textView.text = "이것은 테스트 문자열입니다"
        return textView
    }()
    
    let preferredLabel: UILabel = {
        let label = UILabel()
        label.text = "이런 분들이 함께하면 좋아요"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    lazy var preferredTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsetsMake(0, 8, 0, 0)
        textView.textColor = .darkGray
        textView.backgroundColor = .white
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        textView.text = "이것은 테스트 문자열입니다"
        return textView
    }()
    
    lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.makeViaRgb(red: 74, green: 144, blue: 226)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        button.setTitle("모임 가입 신청", for: .normal)
        return button
    }()
    
    
    func applyButtonTapped() {
        if let _ = FIRAuth.auth()?.currentUser?.uid {
            if let attachedViewContriller = attachedViewController {
                let submitJoinViewController = SubmitJoinViewController()
                if let meetingId = meetingId {
                    submitJoinViewController.meetingId = meetingId
                }
                attachedViewContriller.present(submitJoinViewController, animated: true, completion: nil)
            }
        } else {
            
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubViews()
        setConstraints()
    }
    
    fileprivate func addSubViews() {
        addSubview(profileLabel)
        addSubview(profileTextView)
        addSubview(preferredLabel)
        addSubview(preferredTextView)
        addSubview(locationLabel)
        addSubview(locationTextView)
        addSubview(googlemapView)
        addSubview(applyButton)
    }
    
    fileprivate func setConstraints() {
        _ = profileLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 24)
        
        _ = profileTextView.anchor(profileLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 120)
        
        _ = preferredLabel.anchor(profileTextView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 24)
        
        _ = preferredTextView.anchor(preferredLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 120)
        
        _ = locationLabel.anchor(preferredTextView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 24)
        
        _ = locationTextView.anchor(locationLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 18)
        
        _ = applyButton.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 16, rightConstant: 12, widthConstant: 0, heightConstant: 48)
        
        _ = googlemapView.anchor(locationTextView.bottomAnchor, left: leftAnchor, bottom: applyButton.topAnchor, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 12, rightConstant: 12, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func showSavedLocation(lat: Double, lng: Double, address: String) {
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 15)
        let mapView = GMSMapView.map(withFrame: CGRect(), camera: camera)
        mapView.isMyLocationEnabled = true
        googlemapView.camera = camera
        
        let marker = GMSMarker()
        
        marker.position = CLLocationCoordinate2DMake(lat, lng)
        marker.title = address
        //marker.snippet = "Republic of Korea"
        marker.map = googlemapView
    }
    

    
}

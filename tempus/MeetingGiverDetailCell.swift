//
//  MeetingGiverDetailCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 16..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import GoogleMaps

class MeetingGiverDetailCell: BaseCell {
    
    lazy var googlemapView: GMSMapView = {
        let view = GMSMapView()
        view.settings.scrollGestures = false
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
        return textView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "PRICE"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    lazy var priceTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsetsMake(0, 8, 0, 0)
        textView.textColor = .darkGray
        textView.backgroundColor = .white
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
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
        return textView
    }()
    
    lazy var applyButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = UIColor.makeViaRgb(red: 74, green: 144, blue: 226)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        button.setTitle("기버와의 만남 신청", for: .normal)
        return button
    }()
    
    
    func applyButtonTapped() {
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubViews()
        setConstraints()
        showSavedLocation()
    }
    
    fileprivate func addSubViews() {
        addSubview(profileLabel)
        addSubview(profileTextView)
        addSubview(priceLabel)
        addSubview(priceTextView)
        addSubview(preferredLabel)
        addSubview(preferredTextView)
        addSubview(locationLabel)
        addSubview(locationTextView)
        addSubview(googlemapView)
        addSubview(applyButton)
    }
    
    fileprivate func setConstraints() {
        _ = profileLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 24)
        
        _ = profileTextView.anchor(profileLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 120)
        
        _ = priceLabel.anchor(profileTextView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 24)
        
        _ = priceTextView.anchor(priceLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 120)
        
        _ = preferredLabel.anchor(priceTextView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 24)
        
        _ = preferredTextView.anchor(preferredLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 120)
        
        _ = locationLabel.anchor(preferredTextView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 24)
        
        _ = locationTextView.anchor(locationLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 18)
        
        _ = applyButton.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 16, rightConstant: 12, widthConstant: 0, heightConstant: 48)
        
        _ = googlemapView.anchor(locationTextView.bottomAnchor, left: leftAnchor, bottom: applyButton.topAnchor, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 12, rightConstant: 12, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func showSavedLocation() {
        let camera = GMSCameraPosition.camera(withLatitude: 37.621262, longitude: -122.378945, zoom: 12)
        googlemapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        googlemapView.camera = camera
        
        let currentLocation = CLLocationCoordinate2DMake(37.621262, -122.378945)
        let marker = GMSMarker(position: currentLocation)
        marker.title = "SFO Airport"
        marker.snippet = "Republic of Korea"
        marker.map = googlemapView
    }
    
}

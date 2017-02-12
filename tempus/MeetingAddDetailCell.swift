//
//  MeetingAddDetailCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 12..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MeetingAddDetailCell: BaseCell, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {

    var attachedViewController: MeetingAddViewController?
    
    var titleCharNumber: Int = 0
    var subtitleCharNumber: Int = 0
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.delegate = self
        return locationManager
    }()
    
    let panelView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var googlemapView: GMSMapView = {
        let view = GMSMapView()
        view.delegate = self
        view.isMyLocationEnabled = true
        view.settings.myLocationButton = true
        return view
    }()
    
    let panelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "프로필 작성"
        return label
    }()
    
    lazy var detailImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder3")
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(detailImageTapped)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "가격"
        return label
    }()
    
    lazy var priceField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor.makeViaRgb(red: 216, green: 216, blue: 216)
        textField.delegate = self
        return textField
    }()
    
    let preferredPersonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "선호하는 대상"
        return label
    }()
    
    lazy var preferredPersonField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor.makeViaRgb(red: 216, green: 216, blue: 216)
        textField.delegate = self
        return textField
    }()
    
    let personalRecordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "개인 이력"
        return label
    }()
    
    lazy var personalRecordTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .black
        textView.backgroundColor = UIColor.makeViaRgb(red: 216, green: 216, blue: 216)
        textView.delegate = self
        return textView
    }()
    
    let textLengthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "제목: 0 / 20, 부제목: 0 / 40"
        label.textAlignment = .right
        return label
    }()
    
    func detailImageTapped() {
        if let attachedViewController = self.attachedViewController {
            attachedViewController.presentImagePickerController(.savedPhotosAlbum, imgTag: 0)
        }
    }
    
    func initGoogleMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6)
        let mapView = GMSMapView.map(withFrame: CGRect(), camera: camera)
        mapView.isMyLocationEnabled = true
        googlemapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    override func setupViews() {
        super.setupViews()
        addSubviews()
        setConstraints()
        initGoogleMap()
        
        
    }
    
    fileprivate func addSubviews() {
        addSubview(panelView)
        addSubview(panelLabel)
        addSubview(detailImageView)
        addSubview(priceLabel)
        addSubview(priceField)
        addSubview(preferredPersonLabel)
        addSubview(preferredPersonField)
        addSubview(personalRecordLabel)
        addSubview(personalRecordTextView)
        addSubview(textLengthLabel)
        addSubview(googlemapView)
    }
    
    fileprivate func setConstraints() {
        _ = panelView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        _ = panelLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 36)
        
        _ = detailImageView.anchor(panelLabel.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width / 4, heightConstant: frame.width / 2)
        
        _ = priceLabel.anchor(panelLabel.bottomAnchor, left: detailImageView.rightAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 16)
        
        _ = priceField.anchor(priceLabel.bottomAnchor, left: detailImageView.rightAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        _ = personalRecordLabel.anchor(priceField.bottomAnchor, left: detailImageView.rightAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 16)
        
        _ = personalRecordTextView.anchor(personalRecordLabel.bottomAnchor, left: detailImageView.rightAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 42)
        
        _ = textLengthLabel.anchor(panelView.topAnchor, left: nil, bottom: nil, right: panelView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 220, heightConstant: 20)
        
        _ = googlemapView.anchor(personalRecordTextView.bottomAnchor, left: panelView.leftAnchor, bottom: panelView.bottomAnchor, right: panelView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText: NSString = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        if newText.length > 20 {
            self.textLengthLabel.textColor = UIColor.red
            //self.titleField.text = newText.substring(to: 19)
        } else {
            self.textLengthLabel.textColor = UIColor.darkGray
        }
        
        titleCharNumber = newText.length
        self.textLengthLabel.text = "제목: \(titleCharNumber) / 20, 부제목: \(subtitleCharNumber) / 40"
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.titleField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newText: NSString = textView.text! as NSString
        newText = newText.replacingCharacters(in: range, with: text) as NSString
        
        if newText.length > 40 {
            self.textLengthLabel.textColor = UIColor.red
            //self.subtitleTextView.text = newText.substring(to: 39)
        } else {
            self.textLengthLabel.textColor = UIColor.darkGray
        }
        
        subtitleCharNumber = newText.length
        self.textLengthLabel.text = "제목: \(titleCharNumber) / 20, 부제목: \(subtitleCharNumber) / 40"
        return true
    }
    
    // MARK : CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while get location \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.googlemapView.animate(to: camera)
    }
    
    // MARK : GMSMapView Delegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.googlemapView.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.googlemapView.isMyLocationEnabled = true
        if gesture {
            mapView.selectedMarker = nil
        }
    }
    
    
}

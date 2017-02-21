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

class MeetingAddDetailCell: BaseCell, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate {

    var attachedViewController: MeetingAddViewController?
    
    var preferredPersonCharNumber: Int = 0
    var personalRecordCharNumber: Int = 0
    
    var marker: GMSMarker?
    var alertController: UIAlertController?
    
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
        view.layer.cornerRadius = 8
        return view
    }()
    
    let panelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "세부사항 슬라이드"
        return label
    }()
    
    let preferredPersonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "선호하는 대상"
        return label
    }()
    
    lazy var preferredPersonTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .black
        textView.backgroundColor = UIColor.makeViaRgb(red: 234, green: 234, blue: 234)
        textView.layer.cornerRadius = 8
        textView.delegate = self
        return textView
    }()
    
    let personalRecordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "개인 이력"
        return label
    }()
    
    lazy var personalRecordTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .black
        textView.layer.cornerRadius = 8
        textView.backgroundColor = UIColor.makeViaRgb(red: 234, green: 234, blue: 234)
        textView.delegate = self
        return textView
    }()
    
    let textLengthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "선호대상: 0 / 200, 개인이력: 0 / 280"
        label.textAlignment = .right
        return label
    }()
    
    let preferredLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "선호하는 위치"
        return label
    }()
    
    lazy var locationSearchButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = .cyan
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("위치 검색", for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(locationSearchButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()

    func presentAlert(message:String) {
        if let attachedViewController = self.attachedViewController, let alertController = self.alertController {
            alertController.message = message
            attachedViewController.present(alertController, animated: true)
        }
    }
    
    func traceSavedLocation(latitude: Double, longitude: Double, address: String) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16)
        self.googlemapView.camera = camera
        
        googlemapView.clear()
        
        let position = CLLocationCoordinate2DMake(latitude, longitude)
        self.marker = GMSMarker(position: position)
        marker?.title = address
        marker?.map = googlemapView
        
        preferredLocationLabel.text = "선호하는 위치 : \(address)"
    }
    
    override func setupViews() {
        super.setupViews()
        addSubviews()
        setConstraints()
        initGoogleMap()
        setAlertViewUI()

        self.contentView.isUserInteractionEnabled = false
    }
    
    fileprivate func initGoogleMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 37.6183087, longitude: 126.9390451, zoom: 16)
        let mapView = GMSMapView.map(withFrame: CGRect(), camera: camera)
        mapView.isMyLocationEnabled = true
        googlemapView.camera = camera
            
        let marker = GMSMarker()
        
        marker.position = CLLocationCoordinate2DMake(37.6183087, 126.9390451)
        marker.title = "Seoul"
        marker.snippet = "Republic of Korea"
        marker.map = mapView
    }
    
    fileprivate func setAlertViewUI() {
        alertController = UIAlertController(title: "입력 경고", message: "", preferredStyle: .alert)
        alertController?.addAction(UIAlertAction(title: "확인", style: .default) { action in })
    }
    
    fileprivate func addSubviews() {
        addSubview(panelView)
        addSubview(panelLabel)
        addSubview(preferredPersonLabel)
        addSubview(preferredPersonTextView)
        addSubview(personalRecordLabel)
        addSubview(personalRecordTextView)
        addSubview(preferredLocationLabel)
        addSubview(locationSearchButton)
        addSubview(textLengthLabel)
        addSubview(googlemapView)
    }
    
    fileprivate func setConstraints() {
        _ = panelView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        _ = panelLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        _ = preferredLocationLabel.anchor(panelLabel.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        _ = locationSearchButton.anchor(preferredLocationLabel.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 34)
        
        _ = googlemapView.anchor(locationSearchButton.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.height / 3)
        
        _ = textLengthLabel.anchor(googlemapView.bottomAnchor, left: nil, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 240, heightConstant: 20)
        
        _ = preferredPersonLabel.anchor(googlemapView.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        _ = preferredPersonTextView.anchor(preferredPersonLabel.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
        
        _ = personalRecordLabel.anchor(preferredPersonTextView.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        _ = personalRecordTextView.anchor(personalRecordLabel.bottomAnchor, left: panelView.leftAnchor, bottom: panelView.bottomAnchor, right: panelView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let attachedViewController = self.attachedViewController {
            if textView == personalRecordTextView {
                attachedViewController.submitData.profile = textView.text!
            } else if textView == preferredPersonTextView {
                attachedViewController.submitData.preferred = textView.text!
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newText: NSString = textView.text! as NSString
        newText = newText.replacingCharacters(in: range, with: text) as NSString
        
        if textView == self.preferredPersonTextView {
            if newText.length > 200 {
                self.textLengthLabel.textColor = UIColor.red
                self.preferredPersonTextView.text = newText.substring(to: 199)
            } else {
                self.textLengthLabel.textColor = UIColor.darkGray
            }
            preferredPersonCharNumber = newText.length
        } else if textView == self.personalRecordTextView {
            if newText.length > 280 {
                self.textLengthLabel.textColor = UIColor.red
                self.personalRecordTextView.text = newText.substring(to: 279)
            } else {
                self.textLengthLabel.textColor = UIColor.darkGray
            }
            personalRecordCharNumber = newText.length
        }
        self.textLengthLabel.text = "선호대상: \(preferredPersonCharNumber) / 200, 개인이력: \(personalRecordCharNumber) / 280"
        return true
    }
    
    // MARK : CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while get location \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let location = locations.last
        //let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        //self.googlemapView.animate(to: camera)
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
    
    // MARK : Google Map Auto Complete
    
    func locationSearchButtonTapped() {
        print("Auto Search Button Tapped")
        if let attachedViewController = self.attachedViewController {
            let autoCompleteController = GMSAutocompleteViewController()
            autoCompleteController.delegate = self
            self.locationManager.startUpdatingLocation()
            attachedViewController.present(autoCompleteController, animated: true, completion: nil)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if let attachedViewController = self.attachedViewController {
            if let address = place.formattedAddress {
                traceSavedLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, address: address)
                attachedViewController.submitData.address = address
                attachedViewController.submitData.latitude = place.coordinate.latitude
                attachedViewController.submitData.longitude = place.coordinate.longitude
            }
            attachedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        if let attachedViewController = self.attachedViewController {
            attachedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
}

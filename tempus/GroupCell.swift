//
//  GroupCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 22..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class GroupCell: UITableViewCell {
    
    var group: Group? {
        didSet {
            if let group = self.group {
                self.groupImageView.imageUrlString = group.imageUrl
                self.titleTextView.text = group.name
            }
        }
    }

    struct GroupData {
        static let profileImageSize: CGFloat = 48
        static let positionLabel: CGFloat = 64
    }
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 22)
        textView.textColor = UIColor.makeViaRgb(red: 36, green: 36, blue: 36)
        textView.textAlignment = .right
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    let groupImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder image")
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let overlayCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .white//UIColor.makeViaRgb(red: 0, green: 159, blue: 232)
        view.alpha = 0.3
        return view
    }()
    
    let gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = self.overlayView.bounds
        
        let color1 = UIColor.clear.cgColor as CGColor
        let color2 = UIColor.white.cgColor as CGColor
        //let color3 = UIColor.white.cgColor as CGColor
        //let color4 = UIColor.clear.cgColor as CGColor
        gradientLayer.colors = [color1, color2]//, color3, color4]
        //gradientLayer.locations = [0.0, 0.1, 0.9, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.overlayView.layer.addSublayer(gradientLayer)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubViews()
        setConstriants()
    }
    
    fileprivate func addSubViews() {
        addSubview(groupImageView)
        addSubview(overlayView)
        //addSubview(overlayCoverView)
        addSubview(titleTextView)
        addSubview(timeLabel)
    }
    
    fileprivate func setConstriants() {
        _ = groupImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width * 0.72, heightConstant: 0)
        
        _ = overlayView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width * 0.72, heightConstant: 0)
        
        //_ = overlayCoverView.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: overlayView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width * 0.2, heightConstant: 0)
        
        _ = titleTextView.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: frame.width * 0.6, heightConstant: 0)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//
//
//import UIKit
//import Firebase
//
//class GroupCell: UITableViewCell {
//    
//    var message: Message? {
//        didSet {
//            setUserProfile()
//            self.detailTextLabel?.text = message?.text
//            if let seconds = message?.timestamp?.doubleValue {
//                let dateTime = Date(timeIntervalSince1970: seconds)
//                let formatter = DateFormatter()
//                formatter.dateFormat = "hh:mm:ss a"
//                timeLabel.text = formatter.string(from: dateTime)
//            }
//        }
//    }
//    
//    struct UserData {
//        static let profileImageSize: CGFloat = 48
//        static let positionLabel: CGFloat = 64
//    }
//    
//    
//    let timeLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12)
//        label.textColor = .lightGray
//        label.textAlignment = .right
//        return label
//    }()
//    
//    let profileImageView: DownloadImageView = {
//        let imageView = DownloadImageView()
//        imageView.image = UIImage(named: "placeholder human")
//        imageView.layer.cornerRadius = UserData.profileImageSize / 2
//        imageView.layer.masksToBounds = true
//        imageView.layer.borderColor = UIColor.darkGray.cgColor
//        imageView.layer.borderWidth = 1.2
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        textLabel?.frame = CGRect(x: UserData.positionLabel, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
//        detailTextLabel?.frame = CGRect(x: UserData.positionLabel, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
//    }
//    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//        
//        addSubViews()
//        setConstriants()
//    }
//    
//    fileprivate func addSubViews() {
//        addSubview(profileImageView)
//        addSubview(timeLabel)
//    }
//    
//    fileprivate func setConstriants() {
//        _ = profileImageView.anchor(nil, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: UserData.profileImageSize, heightConstant: UserData.profileImageSize)
//        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        
//        _ = timeLabel.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 0)
//    }
//    
//    fileprivate func setUserProfile() {
//        if let id = message?.chatWithSomeone() {
//            FirebaseDataService.instance.userRef.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
//                if let value = snapshot.value as? Dictionary<String, AnyObject> {
//                    self.textLabel?.text = value[Constants.Users.username] as? String
//                    if let profileImageUrl = value[Constants.Users.imageUrl] as? String {
//                        self.profileImageView.imageUrlString = profileImageUrl
//                    }
//                }
//            })
//        }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

//
//  UserCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 16..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            setUserProfile()
            self.detailTextLabel?.text = message?.text
            if let seconds = message?.timestamp?.doubleValue {
                let dateTime = Date(timeIntervalSince1970: seconds)
                let formatter = DateFormatter()
                formatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = formatter.string(from: dateTime)
            }
        }
    }
    
    struct UserData {
        static let profileImageSize: CGFloat = 48
        static let positionLabel: CGFloat = 64
    }
    
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    let profileImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder human")
        imageView.layer.cornerRadius = UserData.profileImageSize / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 1.2
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: UserData.positionLabel, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: UserData.positionLabel, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubViews()
        setConstriants()
    }
    
    fileprivate func addSubViews() {
        addSubview(profileImageView)
        addSubview(timeLabel)
    }
    
    fileprivate func setConstriants() {
        _ = profileImageView.anchor(nil, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: UserData.profileImageSize, heightConstant: UserData.profileImageSize)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        _ = timeLabel.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 0)
    }
    
    fileprivate func setUserProfile() {
        if let id = message?.chatWithSomeone() {
            FirebaseDataService.instance.userRef.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? Dictionary<String, AnyObject> {
                    self.textLabel?.text = value[Constants.Users.username] as? String
                    if let profileImageUrl = value[Constants.Users.imageUrl] as? String {
                        self.profileImageView.imageUrlString = profileImageUrl
                    }
                }
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

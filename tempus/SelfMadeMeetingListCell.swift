//
//  SelfMadeMeetingListCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 20..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase



class SelfMadeMeetingListCell: UITableViewCell {

    var meeting: MinimizedMeeting? {
        didSet {
            if let meeting = meeting {
                if let isPassed = meeting.isPassed {
                    setCurrentStatusLabel(isPassed: isPassed)
                }
                
                if let title = meeting.title {
                    self.textLabel?.text = title
                }
                
                if let subTitle = meeting.subTitle {
                    self.detailTextLabel?.text = subTitle
                }
                
                if let imageUrl = meeting.imageUrl {
                    self.profileImageView.imageUrlString = imageUrl
                }
            }
        }
    }
    
    struct SelfMadeMeetingListData {
        static let profileImageSize: CGFloat = 72
        static let positionLabel: CGFloat = 64
    }
    
    
    let currentStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .right
        label.text = "HH:MM:SS"
        return label
    }()
    
    fileprivate func setCurrentStatusLabel(isPassed: Bool) {
        var status: String = ""
        let attributedText = NSMutableAttributedString(string: "")
        let attachmentMeetingType = NSTextAttachment()
        
        if isPassed {
            attachmentMeetingType.image = UIImage(named: "icon pause")
            status = "중단됨"
        } else {
            attachmentMeetingType.image = UIImage(named: "icon play")
            status = "진행중"
        }
    
        attachmentMeetingType.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        attributedText.append(NSAttributedString(attachment: attachmentMeetingType))
        attributedText.append(NSAttributedString(string:(" " + status), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.lightGray]))
        currentStatusLabel.attributedText = attributedText
    }
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let profileImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder1")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .black
        
        textLabel?.frame = CGRect(x: 16, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        textLabel?.textColor = .white
        detailTextLabel?.frame = CGRect(x: 16, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        detailTextLabel?.textColor = .white
        
        gradientLayer.frame = self.overlayView.bounds
        
        let color1 = UIColor.black.cgColor as CGColor
        let color2 = UIColor.clear.cgColor as CGColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 0.78]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.7)
        self.overlayView.layer.addSublayer(gradientLayer)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubViews()
        setConstriants()
        textLabel?.text = "시험용"
        detailTextLabel?.text = "나도시험용"
    }
    
    fileprivate func addSubViews() {
        addSubview(profileImageView)
        addSubview(overlayView)
        addSubview(currentStatusLabel)
    }
    
    let gradientLayer = CAGradientLayer()
    
    
    fileprivate func setConstriants() {
        _ = profileImageView.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: SelfMadeMeetingListData.profileImageSize + 20, heightConstant: SelfMadeMeetingListData.profileImageSize)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        _ = overlayView.anchor(profileImageView.topAnchor, left: profileImageView.leftAnchor, bottom: profileImageView.bottomAnchor, right: profileImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = currentStatusLabel.anchor(topAnchor, left: nil, bottom: nil, right: profileImageView.leftAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 2, widthConstant: 100, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


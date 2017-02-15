//
//  MeetingCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 10..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MeetingCell: BaseCell {
    
    var meetingId: String?
    var attachedViewController: MeetingListViewController?
    
    var meeting: Meeting? {
        didSet {
            if let meeting = meeting {
                self.meetingId = meeting.meetingId
                mainImageView.imageUrlString = meeting.imageUrl
                userProfileImageView.imageUrlString = meeting.userImageUrl
                
                if let title = meeting.title {
                    titleTextView.text = title
                }
                
                if let subTitle = meeting.subTitle {
                    subtitleTextView.text = subTitle
                }
                
                if let type = meeting.type {
                    setMeetingTypeLabel(type: type)
                }
                
                if let username = meeting.username {
                    
                }
                
                if let followers = meeting.followers {
                    
                }
                
                if let comments = meeting.comments {
                    
                }
            }
        }
    }
    
    /*
     *  UI Components
     */
    lazy var mainImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainPanelTapped)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let userProfileImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder1")
        imageView.layer.cornerRadius = Constants.userProfileImageSize.small / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 28)
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.text = "강교혁 기버와 함께하는 \n창업이야기"
        textView.isEditable = false
        textView.isSelectable = false
        textView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainPanelTapped)))
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    lazy var subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 0)
        textView.textColor = .lightGray
        textView.backgroundColor = .clear
        textView.text = "강교혁 기버만이 가진 창업노하우를 같이 공유합니다"
        textView.isEditable = false
        textView.isSelectable = false
        textView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainPanelTapped)))
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let giverLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        
        return label
    }()
    
    let meetingTypeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "placeholder1"), for: .normal)
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func moreButtonTapped() {
        print("More button Tapped")
    }
    
    func mainPanelTapped() {
        if let attachedViewController = self.attachedViewController {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let slideViewController = SlideViewController(collectionViewLayout: layout)
            attachedViewController.present(slideViewController, animated: false, completion: nil)
        }
    }
    
    fileprivate func setMeetingTypeLabel(type: String) {
        var type: String = ""
        let attributedText = NSMutableAttributedString(string: "")
        let attachmentMeetingType = NSTextAttachment()
        
        if type == Constants.MeetingType.counseling {
            type = "카운셀링"
            attachmentMeetingType.image = UIImage(named: "icon chat")
        } else if type == Constants.MeetingType.experience {
            type = "체험"
            attachmentMeetingType.image = UIImage(named: "icon meet")
        } else if type == Constants.MeetingType.mentoring {
            type = "멘토링"
            attachmentMeetingType.image = UIImage(named: "icon myPage")
        } else if type == Constants.MeetingType.networking {
            type = "네트워킹"
            attachmentMeetingType.image = UIImage(named: "icon setting")
        } else {
            type = "카운셀링"
            attachmentMeetingType.image = UIImage(named: "icon chat")
        }
        
        attachmentMeetingType.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        attributedText.append(NSAttributedString(attachment: attachmentMeetingType))
        attributedText.append(NSAttributedString(string:(" " + type), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.lightGray]))
        meetingTypeLabel.attributedText = attributedText
    }
    
    fileprivate func setGiverLabel(username: String?, followers: Int?, comments: Int?) {
        var numF: Int = 0
        var numC: Int = 0
        
        if let name = username {
            let attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)])
            attributedText.append(NSAttributedString(string: "\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 6
            
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, attributedText.string.characters.count))
            
            let attachmentHeart = NSTextAttachment()
            let attachmentComment = NSTextAttachment()
            attachmentHeart.image = UIImage(named: "placeholder1")
            attachmentHeart.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
            attachmentComment.image = UIImage(named: "placeholder2")
            attachmentComment.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
            
            attributedText.append(NSAttributedString(attachment: attachmentHeart))
            
            if let numFollowers = followers {
                numF = numFollowers
            }
            
            if let numComments = comments {
                numC = numComments
            }
            
            attributedText.append(NSAttributedString(string: " \(numF)  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.lightGray]))
            attributedText.append(NSAttributedString(attachment: attachmentComment))
            attributedText.append(NSAttributedString(string: " \(numC) ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.lightGray]))
            giverLabel.attributedText = attributedText
        }
    }
    
    override func setupViews() {
        super.setupViews()
        addSubViews()
        setConstraints()
    }
    
    fileprivate func addSubViews() {
        addSubview(mainImageView)
        addSubview(userProfileImageView)
        addSubview(giverLabel)
        addSubview(meetingTypeLabel)
        addSubview(moreButton)
        addSubview(dividerView)
        addSubview(subtitleTextView)
        addSubview(titleTextView)
    }
    
    fileprivate func setConstraints() {
        _ = mainImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: Constants.sizeStandards.spaceShort, leftConstant: Constants.sizeStandards.spaceShort, bottomConstant: 0, rightConstant: Constants.sizeStandards.spaceShort, widthConstant: 0, heightConstant: frame.width * Constants.sizeStandards.landscapeRatio)
        
        _ = userProfileImageView.anchor(mainImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: Constants.userProfileImageSize.small, heightConstant: Constants.userProfileImageSize.small)
        
        _ = giverLabel.anchor(mainImageView.bottomAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 140, heightConstant: 48)
        
        _ = meetingTypeLabel.anchor(mainImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 100, heightConstant: 28)
        
        _ = moreButton.anchor(meetingTypeLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 20, heightConstant: 20)
        
        _ = dividerView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 1)
        
        _ = subtitleTextView.anchor(nil, left: mainImageView.leftAnchor, bottom: mainImageView.bottomAnchor, right: mainImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 12, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        _ = titleTextView.anchor(nil, left: mainImageView.leftAnchor, bottom: subtitleTextView.topAnchor, right: mainImageView.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 4, rightConstant: 8, widthConstant: 0, heightConstant: 64)
    }
    
}

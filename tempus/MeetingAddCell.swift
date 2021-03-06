//
//  MeetingAddCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 12..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MeetingAddCell: BaseCell, UITextFieldDelegate, UITextViewDelegate {

    var storyTitleCharNumber: Int = 0 {
        didSet {
            self.textLengthLabel.text = "스토리제목: \(storyTitleCharNumber) / 20, 스토리라인: \(storySubtitleCharNumber) / 120"
            if let attachedViewController = self.attachedViewController, let tag = self.imgTag {
                attachedViewController.submitData.slides[tag - 2].storyTitleCharNumber = storyTitleCharNumber
            }
        }
    }
    
    var storySubtitleCharNumber: Int = 0 {
        didSet {
            self.textLengthLabel.text = "스토리제목: \(storyTitleCharNumber) / 20, 스토리라인: \(storySubtitleCharNumber) / 120"
            if let attachedViewController = self.attachedViewController, let tag = self.imgTag {
                attachedViewController.submitData.slides[tag - 2].storySubtitleCharNumber = storySubtitleCharNumber
            }
        }
    }
    
    var attachedViewController: MeetingAddViewController?
    
    var imgTag: Int? {
        didSet {
            if let tag = imgTag {
                panelLabel.text = "스토리 \(tag - 1)"
            }
        }
    }
    
    var storyTitle: String? {
        didSet {
            if let storyTitle = storyTitle {
                storyTitleField.text = storyTitle
            }
        }
    }
    
    var storySubtitle: String? {
        didSet {
            if let storySubtitle = storySubtitle {
                storySubtitleTextView.text = storySubtitle
            }
        }
    }

    let panelView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var panelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "스토리"
        return label
    }()
    
    lazy var cellImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder3")
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellImageTapped)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let storyTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "스토리 제목"
        return label
    }()
    
    lazy var storyTitleField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor.makeViaRgb(red: 234, green: 234, blue: 234)
        textField.layer.cornerRadius = 8
        textField.delegate = self
        return textField
    }()
    
    let storySubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "스토리라인"
        return label
    }()
    
    lazy var storySubtitleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .black
        textView.backgroundColor = UIColor.makeViaRgb(red: 234, green: 234, blue: 234)
        textView.layer.cornerRadius = 8
        textView.delegate = self
        return textView
    }()
    
    lazy var addStoryButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = .cyan
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("스토리 추가", for: .normal)
        button.addTarget(self, action: #selector(addStoryButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var deleteStoryButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = .purple
        button.setTitleColor(.white, for: .normal)
        button.setTitle("현재 스토리 삭제", for: .normal)
        button.addTarget(self, action: #selector(deleteStoryButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    let textLengthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "스토리제목: 0 / 20, 스토리라인: 0 / 120"
        label.textAlignment = .right
        return label
    }()
    
    let addStoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "당신의 이야기를 더 추가할 수 있습니다"
        return label
    }()
    
    func cellImageTapped() {
        if let attachedViewController = self.attachedViewController {
            if let imgTag = self.imgTag {
                attachedViewController.presentImagePickerController(.savedPhotosAlbum, imgTag: imgTag)
            }
        }
    }
    
    func addStoryButtonTapped() {
        if let attachedViewController = self.attachedViewController {
            attachedViewController.numStories += 1
            attachedViewController.subImages.append(UIImage(named: "placeholder image")!)
            attachedViewController.submitData.slides.append(Slides())
            attachedViewController.collectionView?.reloadData()
        }
    }
    
    func deleteStoryButtonTapped() {
        if let attachedViewController = self.attachedViewController {
            attachedViewController.numStories -= 1
            attachedViewController.subImages.removeLast()
            attachedViewController.submitData.slides.removeLast()
            attachedViewController.collectionView?.reloadData()
        }
    }
    
    func resetMeetingCell(isFirst: Bool, isLast: Bool) {
        if isLast == true {
            addStoryLabel.isHidden = false
            addStoryButton.isHidden = false
            if isFirst == true {
                deleteStoryButton.isHidden = true
            } else {
                deleteStoryButton.isHidden = false
            }
        } else {
            addStoryLabel.isHidden = true
            addStoryButton.isHidden = true
            deleteStoryButton.isHidden = true
        }
    }
    
    override func setupViews() {
        super.setupViews()
        addSubViews()
        setConstraints()
    }

    fileprivate func addSubViews() {
        addSubview(panelView)
        addSubview(panelLabel)
        addSubview(cellImageView)
        addSubview(storyTitleLabel)
        addSubview(storyTitleField)
        addSubview(storySubtitleLabel)
        addSubview(storySubtitleTextView)
        addSubview(addStoryLabel)
        addSubview(addStoryButton)
        addSubview(deleteStoryButton)
        addSubview(textLengthLabel)
    }
    
    fileprivate func setConstraints() {
        _ = panelView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        _ = panelLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        _ = cellImageView.anchor(panelLabel.bottomAnchor, left: nil, bottom: nil, right: panelView.rightAnchor, topConstant: 26, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width / 4, heightConstant: frame.width / 4 + 22)
        
        _ = storyTitleLabel.anchor(panelLabel.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: cellImageView.leftAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 16)
        
        _ = storyTitleField.anchor(storyTitleLabel.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: cellImageView.leftAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 28)
        
        _ = storySubtitleLabel.anchor(storyTitleField.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: cellImageView.leftAnchor, topConstant: 6, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 16)
        
        _ = storySubtitleTextView.anchor(storySubtitleLabel.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: cellImageView.leftAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 64)
        
        _ = addStoryLabel.anchor(storySubtitleTextView.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 6, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 16)
        
        _ = addStoryButton.anchor(addStoryLabel.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: (frame.width - 16) / 2 - 4, heightConstant: 36)
        
        _ = deleteStoryButton.anchor(addStoryLabel.bottomAnchor, left: addStoryButton.rightAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 2, leftConstant: 1, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 36)
        
        _ = textLengthLabel.anchor(panelView.topAnchor, left: nil, bottom: nil, right: panelView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 260, heightConstant: 20)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let attachedViewController = self.attachedViewController, let imgTag = self.imgTag, let text = textField.text {
            attachedViewController.submitData.slides[imgTag - 2].storyTitle = text
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText: NSString = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString

        if newText.length > 20 {
            self.textLengthLabel.textColor = UIColor.red
            self.storyTitleField.text = newText.substring(to: 19)
        } else {
            self.textLengthLabel.textColor = UIColor.darkGray
        }
        storyTitleCharNumber = newText.length
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let attachedViewController = self.attachedViewController, let imgTag = self.imgTag, let text = textView.text   {
            attachedViewController.submitData.slides[imgTag - 2].storySubtitle = text
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newText: NSString = textView.text! as NSString
        newText = newText.replacingCharacters(in: range, with: text) as NSString
        
        if newText.length > 120 {
            self.textLengthLabel.textColor = UIColor.red
            self.storySubtitleTextView.text = newText.substring(to: 119)
        } else {
            self.textLengthLabel.textColor = UIColor.darkGray
        }
        
        storySubtitleCharNumber = newText.length
        return true
    }
}

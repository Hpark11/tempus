//
//  MeetingAddCoverCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 12..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MeetingAddCoverCell: BaseCell, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var attachedViewController: MeetingAddViewController?

    var titleCharNumber: Int = 0
    var subtitleCharNumber: Int = 0
    
    let panelView: UIView = {
        let view = UIView()
        return view
    }()
    
    let panelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "메인"
        return label
    }()
    
    lazy var mainImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder3")
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainImageTapped)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var titleField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor.makeViaRgb(red: 216, green: 216, blue: 216)
        textField.delegate = self
        return textField
    }()
    
    lazy var subtitleTextView: UITextView = {
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
    
    func mainImageTapped() {
        if let attachedViewController = self.attachedViewController {
            attachedViewController.presentImagePickerController(.savedPhotosAlbum, imgTag: 0)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        addSubviews()
        setConstraints()
    }
    
    fileprivate func addSubviews() {
        addSubview(panelView)
        addSubview(panelLabel)
        addSubview(mainImageView)
        addSubview(titleField)
        addSubview(subtitleTextView)
        addSubview(textLengthLabel)
    }
    
    fileprivate func setConstraints() {
        _ = panelView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        _ = panelLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 36)

        _ = mainImageView.anchor(panelLabel.bottomAnchor, left: panelView.leftAnchor, bottom: panelView.bottomAnchor, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width / 4, heightConstant: 0)
        
        _ = titleField.anchor(panelLabel.bottomAnchor, left: mainImageView.rightAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        _ = subtitleTextView.anchor(titleField.bottomAnchor, left: mainImageView.rightAnchor, bottom: panelView.bottomAnchor, right: panelView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = textLengthLabel.anchor(panelView.topAnchor, left: nil, bottom: nil, right: panelView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 220, heightConstant: 20)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText: NSString = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        if newText.length > 20 {
            self.textLengthLabel.textColor = UIColor.red
            self.titleField.text = newText.substring(to: 19)
        } else {
            self.textLengthLabel.textColor = UIColor.darkGray
        }
        
        titleCharNumber = newText.length
        self.textLengthLabel.text = "제목: \(titleCharNumber) / 20, 부제목: \(subtitleCharNumber) / 40"
        
        if let attachedViewController = self.attachedViewController {
            attachedViewController.submitData.cover.title = newText as String
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.titleField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newText: NSString = textView.text! as NSString
        newText = newText.replacingCharacters(in: range, with: text) as NSString
        
        if newText.length > 40 {
            self.textLengthLabel.textColor = UIColor.red
            self.subtitleTextView.text = newText.substring(to: 39)
        } else {
            self.textLengthLabel.textColor = UIColor.darkGray
        }
        
        subtitleCharNumber = newText.length
        self.textLengthLabel.text = "제목: \(titleCharNumber) / 20, 부제목: \(subtitleCharNumber) / 40"
        if let attachedViewController = self.attachedViewController {
            attachedViewController.submitData.cover.subTitle = newText as String
        }
        return true
    }
}

//
//  MeetingAddCoverCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 12..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MeetingAddCoverCell: BaseCell, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var attachedViewController: MeetingAddViewController?

    var titleCharNumber: Int = 0
    var subtitleCharNumber: Int = 0
    
    var categoryDataSource = ["자기계발", "입시", "전문기술", "취미"]
    var typeDataSource = ["카운셀링", "멘토링", "체험", "네트워킹"]
    
    var categoryDataSourceEn = [Constants.Category.selfImprovement, Constants.Category.prepareExamination, Constants.Category.professionalSkills, Constants.Category.lookingForHobby]
    var typeDataSourceEn = [Constants.MeetingType.counseling, Constants.MeetingType.mentoring, Constants.MeetingType.experience, Constants.MeetingType.networking]
    
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
        imageView.image = UIImage()
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainImageTapped)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "메인 타이틀"
        return label
    }()
    
    lazy var titleField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor.makeViaRgb(red: 216, green: 216, blue: 216)
        textField.delegate = self
        return textField
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "서브 타이틀"
        return label
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
    
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "카테고리를 선택하세요"
        return label
    }()
    
    lazy var categoryPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "만남의 유형을 선택하세요"
        return label
    }()
    
    lazy var typePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
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
        addSubview(categoryPickerView)
        addSubview(typePickerView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    
    fileprivate func setConstraints() {
        _ = panelView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        _ = panelLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 36)

        _ = mainImageView.anchor(panelLabel.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width / 4, heightConstant: frame.width / 4 * 16 / 11)
        
        _ = titleLabel.anchor(panelLabel.bottomAnchor, left: mainImageView.rightAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 16)
        
        _ = titleField.anchor(titleLabel.bottomAnchor, left: mainImageView.rightAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        _ = subtitleLabel.anchor(titleField.bottomAnchor, left: mainImageView.rightAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 6, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 16)
        
        _ = subtitleTextView.anchor(subtitleLabel.bottomAnchor, left: mainImageView.rightAnchor, bottom: mainImageView.bottomAnchor, right: panelView.rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = textLengthLabel.anchor(panelView.topAnchor, left: nil, bottom: nil, right: panelView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 220, heightConstant: 20)
        
        _ = categoryPickerView.anchor(subtitleTextView.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 90)
        
        _ = typePickerView.anchor(categoryPickerView.bottomAnchor, left: panelView.leftAnchor, bottom: panelView.bottomAnchor, right: panelView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if let attachedViewController = self.attachedViewController {
            if let text = textField.text {
                attachedViewController.submitData.title = text
            }
        }
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
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.titleField.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let attachedViewController = self.attachedViewController {
            attachedViewController.submitData.subTitle = textView.text
        }
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
        
        return true
    }
    
    // MARK : PickerView Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPickerView {
            return 4
        } else if pickerView == typePickerView {
            return 4
        } else {
            return 4
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPickerView {
            return categoryDataSource[row]
        } else if pickerView == typePickerView {
            return typeDataSource[row]
        } else {
            return "WHat??"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let attachedViewController = self.attachedViewController {
            if pickerView == categoryPickerView {
                attachedViewController.submitData.category = categoryDataSourceEn[row]
            } else if pickerView == typePickerView {
                attachedViewController.submitData.type = typeDataSourceEn[row]
            }
        }
    }
    
}

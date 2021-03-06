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
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "메인 슬라이드"
        return label
    }()
    
    let imageGuideLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "메인 사진을 올려주세요 (세로가 더 긴 사진이 좋답니다 ^^)"
        return label
    }()
    
    lazy var mainImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder image")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainImageTapped)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "메인 타이틀"
        return label
    }()
    
    lazy var titleField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor.makeViaRgb(red: 234, green: 234, blue: 234)
        textField.layer.cornerRadius = 8
        textField.delegate = self
        return textField
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "서브 타이틀"
        return label
    }()
    
    lazy var subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .black
        textView.backgroundColor = UIColor.makeViaRgb(red: 234, green: 234, blue: 234)
        textView.layer.cornerRadius = 8
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
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "카테고리를 선택하세요"
        return label
    }()
    
    lazy var categoryPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.layer.borderColor = UIColor.darkGray.cgColor
        pickerView.layer.borderWidth = 1
        return pickerView
    }()
    
    lazy var categorySegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: self.categoryDataSource)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.black
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleCategoryChange), for: .valueChanged)
        return sc
    }()
    
    func handleCategoryChange() {
        if let attachedViewController = self.attachedViewController {
            attachedViewController.submitData.category = categoryDataSourceEn[categorySegmentedControl.selectedSegmentIndex]
        }
    }
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "유형을 선택하세요"
        return label
    }()
    
    lazy var typePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.layer.borderColor = UIColor.darkGray.cgColor
        pickerView.layer.borderWidth = 1
        return pickerView
    }()
    
    lazy var typeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: self.typeDataSource)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.black
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleTypeChange), for: .valueChanged)
        return sc
    }()
    
    func handleTypeChange() {
        if let attachedViewController = self.attachedViewController {
            attachedViewController.submitData.type = typeDataSourceEn[typeSegmentedControl.selectedSegmentIndex]
        }
    }
    
    func mainImageTapped() {
        if let attachedViewController = self.attachedViewController {
            attachedViewController.presentImagePickerController(.photoLibrary, imgTag: 0)
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
        addSubview(imageGuideLabel)
        addSubview(mainImageView)
        addSubview(titleField)
        addSubview(subtitleTextView)
        addSubview(textLengthLabel)
        addSubview(categorySegmentedControl)
        addSubview(typeSegmentedControl)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(categoryLabel)
        addSubview(typeLabel)
    }
    
    fileprivate func setConstraints() {
        _ = panelView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        _ = panelLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)

        _ = imageGuideLabel.anchor(panelLabel.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        _ = mainImageView.anchor(imageGuideLabel.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.height / 2.4)
        
        _ = textLengthLabel.anchor(mainImageView.bottomAnchor, left: nil, bottom: nil, right: panelView.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 220, heightConstant: 20)
        
        _ = titleLabel.anchor(mainImageView.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: textLengthLabel.leftAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 20)
        
        _ = titleField.anchor(titleLabel.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 6, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        _ = subtitleLabel.anchor(titleField.bottomAnchor, left: panelView.leftAnchor, bottom: nil, right: panelView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        _ = typeSegmentedControl.anchor(nil, left: panelView.leftAnchor, bottom: panelView.bottomAnchor, right: panelView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 24)
        
        _ = typeLabel.anchor(nil, left: panelView.leftAnchor, bottom: typeSegmentedControl.topAnchor, right: panelView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        _ = categorySegmentedControl.anchor(nil, left: panelView.leftAnchor, bottom: typeLabel.topAnchor, right: panelView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 14, rightConstant: 0, widthConstant: 0, heightConstant: 24)
        
        _ = categoryLabel.anchor(nil, left: panelView.leftAnchor, bottom: categorySegmentedControl.topAnchor, right: panelView.rightAnchor, topConstant: 6, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        _ = subtitleTextView.anchor(subtitleLabel.bottomAnchor, left: panelView.leftAnchor, bottom: categoryLabel.topAnchor, right: panelView.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 16, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
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

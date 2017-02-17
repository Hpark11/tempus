//
//  UserProfileModifyCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 17..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class UserProfileModifyCell: BaseCell, UITextFieldDelegate {
    
    var attachedViewController: UserPageViewController?
    var userInfo: Users? {
        didSet {
            if let user = self.userInfo {
                self.emailField.text = user.email
                self.usernameField.text = user.username
                self.introField.text = user.intro
                if user.provider != "Firebase" {
                    self.emailField.isEnabled = false
                    self.passwordField.placeholder = "비밀번호를 변경할 수 없습니다"
                    self.passwordField.isEnabled = false
                    self.passwordConfirmField.placeholder = "비밀번호를 변경할 수 없습니다"
                    self.passwordConfirmField.isEnabled = false
                }
            }
        }
    }
    
    let infoSectionView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.1
        return view
    }()
    
    let passwordSectionView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.1
        return view
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var emailField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "이메일을 입력하세요"
        textField.delegate = self
        return textField
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var usernameField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "닉네임을 입력하세요"
        textField.delegate = self
        return textField
    }()
    
    let introLabel: UILabel = {
        let label = UILabel()
        label.text = "소개말"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var introField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "소개말을 간단하게 적어주세요"
        textField.delegate = self
        return textField
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var passwordField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "새로운 비밀번호를 입력하세요"
        textField.isSecureTextEntry = true
        textField.delegate = self
        return textField
    }()
    
    let passwordConfirmLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var passwordConfirmField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "새로운 비밀번호를 입력하세요"
        textField.isSecureTextEntry = true
        textField.delegate = self
        return textField
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "INFO"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let passwordChangeLabel: UILabel = {
        let label = UILabel()
        label.text = "CHANGE PASSWORD"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let dividerLightViews: [UIView] = {
        var views = [UIView]()
        for i in 0...5 {
            let view = UIView()
            view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
            views.append(view)
        }
        return views
    }()
    
    lazy var alert: UIAlertController = {
        let alert = UIAlertController(title: "삭제에러", message: "진행중에 에러가 발생하였습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in })
        return alert
    }()
    
    lazy var deleteSuccessAlert: UIAlertController = {
        let alert = UIAlertController(title: "삭제에러", message: "그동안 이용해주셔서 감사합니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
            _ = self.attachedViewController?.navigationController?.popViewController(animated: true)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .default) { action in })
        return alert
    }()
    
    func presentAlert(controller: UIAlertController, message:String) {
        controller.message = message
        if let attachedViewController = self.attachedViewController {
            attachedViewController.present(controller, animated: true)
        }
    }
    
    lazy var saveProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.makeViaRgb(red: 0, green: 159, blue: 232)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(saveProfileButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        button.titleLabel?.text = "현재정보 저장하기"
        button.setTitle("현재정보 저장하기", for: .normal)
        return button
    }()
    
    func saveProfileButtonTapped() {
        
    }
    
    lazy var deleteProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.makeViaRgb(red: 255, green: 62, blue: 62)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(deleteProfileButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        button.titleLabel?.text = "계정 삭제하기"
        button.setTitle("계정 삭제하기", for: .normal)
        return button
    }()
    
    func deleteProfileButtonTapped() {
        if let user = FIRAuth.auth()?.currentUser {
            FirebaseDataService.instance.userRef.child(user.uid).removeValue()
            user.delete { error in
                if error != nil {
                    // An error happened.
                    self.presentAlert(controller: self.alert, message: "진행중에 에러가 발생하였습니다")
                } else {
                    KeychainWrapper.standard.removeObject(forKey: Constants.keychainUid)
                    self.presentAlert(controller: self.deleteSuccessAlert, message: "그동안 이용해주셔서 감사합니다")
                }
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubViews()
        setConstraints()
    }
    
    fileprivate func addSubViews() {
        addSubview(infoSectionView)
        addSubview(emailLabel)
        addSubview(emailField)
        addSubview(usernameLabel)
        addSubview(usernameField)
        addSubview(introLabel)
        addSubview(introField)
        addSubview(passwordSectionView)
        addSubview(passwordLabel)
        addSubview(passwordField)
        addSubview(passwordConfirmLabel)
        addSubview(passwordConfirmField)
        addSubview(deleteProfileButton)
        addSubview(saveProfileButton)
        
        infoSectionView.addSubview(infoLabel)
        passwordSectionView.addSubview(passwordChangeLabel)
        
        for dividerView in dividerLightViews {
            addSubview(dividerView)
        }
    }
    
    fileprivate func setConstraints() {
        _ = infoSectionView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 54)
        
        _ = emailLabel.anchor(infoSectionView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 16)
        
        _ = emailField.anchor(emailLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 16)
        
        _ = dividerLightViews[0].anchor(emailField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 3, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 1)
        
        _ = usernameLabel.anchor(emailField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 16)
        
        _ = usernameField.anchor(usernameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 16)
        
        _ = dividerLightViews[1].anchor(usernameField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 3, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 1)
        
        _ = introLabel.anchor(usernameField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 16)
        
        _ = introField.anchor(introLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 16)
        
        _ = dividerLightViews[2].anchor(introField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 3, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 1)
        
        _ = passwordSectionView.anchor(introField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 54)
        
        _ = passwordLabel.anchor(passwordSectionView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 16)
        
        _ = passwordField.anchor(passwordLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 16)
        
        _ = dividerLightViews[3].anchor(passwordField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 3, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 1)
        
        _ = passwordConfirmLabel.anchor(passwordField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 16)
        
        _ = passwordConfirmField.anchor(passwordConfirmLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 16)
        
        _ = dividerLightViews[4].anchor(passwordConfirmField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 3, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 1)
        
        _ = deleteProfileButton.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 32, rightConstant: 16, widthConstant: 0, heightConstant: 44)
        
        _ = saveProfileButton.anchor(nil, left: leftAnchor, bottom: deleteProfileButton.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 10, rightConstant: 16, widthConstant: 0, heightConstant: 44)
        
        _ = infoLabel.anchor(infoSectionView.topAnchor, left: infoSectionView.leftAnchor, bottom: infoSectionView.bottomAnchor, right: infoSectionView.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = passwordChangeLabel.anchor(passwordSectionView.topAnchor, left: passwordSectionView.leftAnchor, bottom: passwordSectionView.bottomAnchor, right: passwordSectionView.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let attachedViewController = self.attachedViewController {
            attachedViewController.setTabBarVisibility(isHidden: true, animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let attachedViewController = self.attachedViewController {
            textField.resignFirstResponder()
            attachedViewController.setTabBarVisibility(isHidden: false, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let attachedViewController = self.attachedViewController {
            textField.resignFirstResponder()
            attachedViewController.setTabBarVisibility(isHidden: false, animated: true)
        }
        return true
    }
}

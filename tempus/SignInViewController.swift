//
//  SignInViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit



class SignInViewController: UIViewController, UITextFieldDelegate {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "placeholder4")
        return imageView
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        button.setTitle("로그인", for: .normal)
        return button
    }()
    
    lazy var signInWithFacebookButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = UIColor.makeViaRgb(red: 74, green: 144, blue: 226)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        button.setTitle("페이스북으로 로그인", for: .normal)
        return button
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["로그인", "회원가입"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.black
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    let dividerView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    let dividerView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    let dividerView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let dividerView4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    lazy var emailField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "이메일을 입력하세요"
        textField.textAlignment = .center
        textField.delegate = self
        return textField
    }()
    
    lazy var passwordField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "비밀번호를 입력하세요"
        textField.textAlignment = .center
        textField.isSecureTextEntry = true
        textField.delegate = self
        return textField
    }()
    
    lazy var passwordConfirmField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "비밀번호를 다시 입력하세요"
        textField.textAlignment = .center
        textField.delegate = self
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var userNameField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "닉네임이나 이름을 입력하세요"
        textField.textAlignment = .center
        textField.delegate = self
        return textField
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "icon cancel") {
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        signInButton.setTitle(title, for: .normal)
    }
    
    func signInButtonTapped() {
        
    }
    
    func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addSubViews()
        setConstraints()
    }
    
    fileprivate func addSubViews() {
        view.addSubview(imageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(signInButton)
        view.addSubview(signInWithFacebookButton)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(passwordConfirmField)
        view.addSubview(userNameField)
        view.addSubview(dividerView1)
        view.addSubview(dividerView2)
        view.addSubview(dividerView3)
        view.addSubview(dividerView4)
        view.addSubview(cancelButton)
    }
    
    fileprivate func setConstraints() {
        _ = imageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.height * 6 / 16)
        
        _ = loginRegisterSegmentedControl.anchor(imageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 32)
        
        _ = emailField.anchor(loginRegisterSegmentedControl.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 32)
        
        _ = dividerView1.anchor(emailField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 1, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 1)
        
        _ = passwordField.anchor(dividerView1.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 32)
        
        _ = dividerView2.anchor(passwordField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 1, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 1)
        
        _ = passwordConfirmField.anchor(dividerView2.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 32)
        
        _ = dividerView3.anchor(passwordConfirmField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 1, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 1)
        
        _ = userNameField.anchor(dividerView3.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 32)
        
        _ = dividerView4.anchor(userNameField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 1, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 1)
        
        
        _ = cancelButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 40)
        
        _ = signInButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 48)
        
        _ = signInWithFacebookButton.anchor(nil, left: view.leftAnchor, bottom: signInButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 8, rightConstant: 16, widthConstant: 0, heightConstant: 48)
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

}

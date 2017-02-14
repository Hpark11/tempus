//
//  SignInViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftKeychainWrapper
import SwiftValidators

class SignInViewController: UIViewController, UITextFieldDelegate {

    struct Alerts {
        static let nameRequired = "사용자명을 입력해주세요"
        static let nameAlphanumeric = "영어와 숫자만 사용 가능합니다"
        static let nameMaxLength = "사용자명은 18자까지 쓸 수 있습니다"
        static let nameMinLength = "사용자명은 4자 이상으로 써주세요"
        static let required = "비밀번호를 입력해주세요"
        static let notAllowed = "허용되지 않는 문자를 입력하셨습니다"
        static let notSame = "작성하신 비밀번호가 동일하지 않습니다"
        static let maxLength = "비밀번호는 30자까지 쓸 수 있습니다"
        static let minLength = "비밀번호는 6자 이상으로 써주세요"
        static let wrong = "잘못된 이메일이나 비밀번호입니다"
        static let success = "회원가입을 축하합니다."
    }
    
    lazy var alert: UIAlertController = {
        let alert = UIAlertController(title: "사용자 등록 경고", message: "With this", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in })
        return alert
    }()
    
    lazy var success: UIAlertController = {
        let success = UIAlertController(title: "회원가입 성공", message: "함께해주셔서 감사합니다", preferredStyle: .alert)
        success.addAction(UIAlertAction(title: "확인", style: .default) { action in })
        return success
    }()
    
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
        button.addTarget(self, action: #selector(signInWithFacebookButtonTapped), for: .touchUpInside)
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
    
    func presentAlert(controller: UIAlertController, message:String) {
        controller.message = message
        self.present(controller, animated: true)
    }
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        signInButton.setTitle(title, for: .normal)
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            setBottomInputVisibility(isHide: true)
        } else {
            setBottomInputVisibility(isHide: false)
        }
    }
    
    func signInWithFacebookButtonTapped() {
        let facebookLoginManager = FBSDKLoginManager()
        facebookLoginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print(":::[HPARK] Unable to authenticate with Facebook \(String(describing: error)):::\n")
            } else if result?.isCancelled == true {
                print(":::[HPARK] App User cancelled Facebook Authentication :::\n")
            } else {
                print(":::[HPARK] Authentication with Facebook Successful :::\n")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print(":::[HPARK] Unable to authenticate with Firebase - \(String(describing: error)) :::\n")
            } else {
                print(":::[HPARK] Successfully authenticated with Firebase :::\n")
                if let user = user, let email = user.email {
                    let dataUser = ["provider": credential.provider, "email": email]
                    FirebaseDataService.instance.createFirebaseDatabaseUser(uid: user.uid, dataUser: dataUser)
                    KeychainWrapper.standard.set(user.uid, forKey: Constants.keychainUid)
                }
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func firebaseSignInWithEmail(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                print(":::[HPARK] Successfully signed in the app with email :::\n")
                if let user = user, let email = user.email {
                    let dataUser = ["provider": user.providerID, "email": email]
                    FirebaseDataService.instance.createFirebaseDatabaseUser(uid: user.uid, dataUser: dataUser)
                    KeychainWrapper.standard.set(user.uid, forKey: Constants.keychainUid)
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print(":::[HPARK] Login failed with \(String(describing: error)) :::\n")
                self.presentAlert(controller: self.alert, message: Alerts.wrong)
            }
        })
    }
    
    func signInButtonTapped() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 { // login button
            if let email = emailField.text, let password = passwordField.text {
                if Validators.isEmpty()(password) {
                    presentAlert(controller: alert, message: Alerts.required)
                    return
                }
                
                if !Validators.isASCII()(password) {
                    presentAlert(controller: alert, message: Alerts.notAllowed)
                    return
                }
                
                firebaseSignInWithEmail(email: email, password: password)
            }
        } else { // register button
            // Username Validation
            if let userName = userNameField.text {
                if Validators.isEmpty()(userName) {
                    presentAlert(controller: alert, message: Alerts.nameRequired)
                    return
                }
                if !Validators.isAlphanumeric()(userName) {
                    presentAlert(controller: alert, message: Alerts.nameAlphanumeric)
                    return
                }
                if !Validators.maxLength(18)(userName) {
                    presentAlert(controller: alert, message: Alerts.nameMaxLength)
                    return
                }
                if !Validators.minLength(4)(userName) {
                    presentAlert(controller: alert, message: Alerts.nameMinLength)
                    return
                }
            } else {
                presentAlert(controller: alert, message: Alerts.nameRequired)
                return
            }
            
            if let email = emailField.text, let password = passwordField.text {
                
                if let passwordConfirm = passwordConfirmField.text {
                    if Validators.isEmpty()(password) || Validators.isEmpty()(passwordConfirm) {
                        presentAlert(controller: alert, message: Alerts.required)
                        return
                    }
                    
                    if !(Validators.isASCII()(password) && Validators.isASCII()(passwordConfirm)) {
                        presentAlert(controller: alert, message: Alerts.notAllowed)
                        return
                    }
                    if !Validators.equals(password)(passwordConfirm) {
                        presentAlert(controller: alert, message: Alerts.notSame)
                        return
                    }
                    if !Validators.maxLength(30)(password) {
                        presentAlert(controller: alert, message: Alerts.maxLength)
                        return
                    }
                    if !Validators.minLength(6)(password) {
                        presentAlert(controller: alert, message: Alerts.minLength)
                        return
                    }
                } else {
                    presentAlert(controller: alert, message: Alerts.required)
                    return
                }
                
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        print(":::[HPARK] Unable to authenticate with email ::: \(String(describing: error))\n")
                        self.presentAlert(controller: self.alert, message: Alerts.wrong)
                    } else {
                        print(":::[HPARK] Successfully authenticated with email ::: \n")
                        self.presentAlert(controller: self.success, message: Alerts.success)
                        self.firebaseSignInWithEmail(email: email, password: password)
                    }
                })
            }
        }
    }
    
    func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func setBottomInputVisibility(isHide: Bool) {
        passwordConfirmField.isHidden = isHide
        userNameField.isHidden = isHide
        dividerView3.isHidden = isHide
        dividerView4.isHidden = isHide
        signInWithFacebookButton.isHidden = !isHide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setBottomInputVisibility(isHide: true)
        
        addSubViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
    
    // get keyboard height and shift the view from bottom to higher
    func keyboardWillShow(_ notification: Notification) {
        if userNameField.isFirstResponder || passwordConfirmField.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if userNameField.isFirstResponder || passwordConfirmField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}

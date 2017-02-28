//
//  DiaryViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 11..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class DiaryViewController: UIViewController {

    lazy var beforeButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "icon cancel") {
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(beforeButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()

    func beforeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        //label.backgroundColor = .clear
        label.text = "당신만의 개성있는 이야기"
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "핸드폰 번호를 적어주세요"
        label.textColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var phoneNumberField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "간단한 자기소개를 적어주세요"
        label.textColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var profileTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8)
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    let reasonLabel: UILabel = {
        let label = UILabel()
        label.text = "모임을 개설하고자 하는 계기"
        label.textColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var mainTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8)
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.layer.cornerRadius = 8
        return textView
    }()

    lazy var sendStoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.makeViaRgb(red: 0, green: 159, blue: 232)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(sendStoryButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        button.titleLabel?.text = "보내기"
        button.setTitle("보내기", for: .normal)
        return button
    }()
    
    lazy var success: UIAlertController = {
        let success = UIAlertController(title: "스토리 등록", message: "", preferredStyle: .alert)
        success.addAction(UIAlertAction(title: "확인", style: .default) { action in
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(dismissCurrentVC), userInfo: nil, repeats: false)
        })
        return success
    }()
    
    func presentAlert(controller: UIAlertController, message:String) {
        controller.message = message
        self.present(controller, animated: true)
    }
    
    func sendStoryButtonTapped() {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            FirebaseDataService.instance.storyRegRef.childByAutoId().setValue([
                Constants.Stories.content: mainTextView.text!,
                Constants.Stories.userId: uid
            ])
            FirebaseDataService.instance.userRef.child(uid).child(Constants.Users.isGroupingAuth).setValue("true")
            presentAlert(controller: success, message: "작성해주셔서 감사합니다 \n작성된 내용은 1~2일정도에 걸쳐 확인될 예정입니다.")
        }
    }
    
    var timer: Timer?
    func dismissCurrentVC() {
        timer?.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        view.addSubview(beforeButton)
        view.addSubview(titleLabel)
        view.addSubview(phoneLabel)
        view.addSubview(phoneNumberField)
        view.addSubview(profileLabel)
        view.addSubview(profileTextView)
        view.addSubview(reasonLabel)
        view.addSubview(mainTextView)
        view.addSubview(sendStoryButton)
    }
    
    fileprivate func setConstraints() {
        _ = beforeButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 40)
        
        _ = titleLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.leftAnchor, topConstant: 30, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 44)
        
        _ = phoneLabel.anchor(titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 20)
        
        _ = phoneNumberField.anchor(phoneLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 24)
        
        _ = profileLabel.anchor(phoneNumberField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 20)
        
        _ = profileTextView.anchor(profileLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: view.frame.height / 3.6)
        
        _ = reasonLabel.anchor(profileTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 20)
        
        _ = sendStoryButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        _ = mainTextView.anchor(reasonLabel.bottomAnchor, left: view.leftAnchor, bottom: sendStoryButton.topAnchor, right: view.rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
    }
    

    // get keyboard height and shift the view from bottom to higher
    func keyboardWillShow(_ notification: Notification) {
        if mainTextView.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if mainTextView.isFirstResponder {
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

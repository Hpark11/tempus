//
//  SubmitJoinViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 20..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class SubmitJoinViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var meetingId: String?
    
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
        label.text = "당신에대해 알고싶어요"
        return label
    }()
    
    let pictureLabel: UILabel = {
        let label = UILabel()
        label.text = "당신을 알 수 있는 사진한장 부탁해요 ~!"
        label.textColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder image")
        return imageView
    }()
    
    let reasonLabel: UILabel = {
        let label = UILabel()
        label.text = "자기소개 부탁드려요"
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
        button.titleLabel?.text = "신청하기"
        button.setTitle("신청하기", for: .normal)
        return button
    }()
    
    lazy var success: UIAlertController = {
        let success = UIAlertController(title: "모임참여 등록", message: "", preferredStyle: .alert)
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
        if let uid = FIRAuth.auth()?.currentUser?.uid, let meetingId = meetingId {
            FirebaseDataService.instance.userRef.child(uid).child(Constants.Users.submission).child(meetingId).setValue([
                "imageUrl": uploadImageView.image!,
                "introduction": mainTextView.text!
            ])
            FirebaseDataService.instance.meetingRef.child(meetingId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let meeting = snapshot.value as? Dictionary<String, AnyObject> {
                    if let wannabe = meeting[Constants.Meetings.wannabe] as? Array<String> {
                        var submit = Array<String>()
                        for key in wannabe {
                            submit.append(key)
                        }
                        FirebaseDataService.instance.meetingRef.child(meetingId).setValue([
                            Constants.Meetings.wannabe: submit as NSArray
                        ])
                    }
                }
            })
            presentAlert(controller: success, message: "등록해주셔서 감사합니다. \n등록하신 내용은 그룹장이 확인 후\n 참여여부를 결정하게됩니다")
        }
    }
    
    var timer: Timer?
    func dismissCurrentVC() {
        timer?.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        view.addSubview(pictureLabel)
        view.addSubview(uploadImageView)
        view.addSubview(reasonLabel)
        view.addSubview(mainTextView)
        view.addSubview(sendStoryButton)
    }
    
    fileprivate func setConstraints() {
        _ = beforeButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 40)
        
        _ = titleLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.leftAnchor, topConstant: 30, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 44)
        
        _ = pictureLabel.anchor(titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 20)
        
        _ = uploadImageView.anchor(pictureLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: view.frame.height / 3.6)
        
        _ = reasonLabel.anchor(uploadImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 20)
        
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

    // present image picker
    func presentImagePickerController(_ source: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = source
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // after finished picking image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.uploadImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // cancel button tapped
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


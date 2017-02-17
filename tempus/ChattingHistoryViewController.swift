//
//  ChattingHistoryViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 16..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class ChattingHistoryViewController: UICollectionViewController, UITextFieldDelegate {
    
    var user: Users? {
        didSet {
            titleLabel.text = user?.username
        }
    }
    
    struct ChattingHistoryData {
        static let inputYSize: CGFloat = 50
    }
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let chatInputView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 220, green: 220, blue: 220)
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("보내기", for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "메세지를 입력하세요"
        textField.delegate = self
        return textField
    }()
    
    func sendButtonTapped() {
        let ref = FirebaseDataService.instance.messageRef.childByAutoId()
        
        let toUserId = user?.uid
        let fromUserId = FIRAuth.auth()?.currentUser?.uid
        
        let values: Dictionary<String, AnyObject> = [
            "text": inputTextField.text! as AnyObject,
            "toUserId": toUserId as AnyObject,
            "fromUserId": fromUserId as AnyObject,
            "timestamp": NSNumber(value: Int(Date().timeIntervalSince1970))
        ]

        ref.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
            
            let userMessageRef = FirebaseDataService.instance.userMessageRef.child(fromUserId!)
            let messageId = ref.key
            userMessageRef.updateChildValues([messageId: 1])
            
            let receipientUserMessageRef = FirebaseDataService.instance.userMessageRef.child(toUserId!)
            receipientUserMessageRef.updateChildValues([messageId : 1])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        navigationItem.titleView = titleLabel
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
        view.addSubview(chatInputView)
        chatInputView.addSubview(sendButton)
        chatInputView.addSubview(inputTextField)
        chatInputView.addSubview(dividerView)
    }
    
    fileprivate func setConstraints() {
        _ = chatInputView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 64, rightConstant: 0, widthConstant: 0, heightConstant: ChattingHistoryData.inputYSize)
        
        _ = sendButton.anchor(nil, left: nil, bottom: nil, right: chatInputView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: ChattingHistoryData.inputYSize)
        sendButton.centerYAnchor.constraint(equalTo: chatInputView.centerYAnchor).isActive = true
        
        _ = inputTextField.anchor(nil, left: chatInputView.leftAnchor, bottom: nil, right: sendButton.leftAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: ChattingHistoryData.inputYSize)
        inputTextField.centerYAnchor.constraint(equalTo: chatInputView.centerYAnchor).isActive = true
        
        _ = dividerView.anchor(chatInputView.topAnchor, left: chatInputView.leftAnchor, bottom: nil, right: chatInputView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonTapped()
        return true
    }
    
    // get keyboard height and shift the view from bottom to higher
    func keyboardWillShow(_ notification: Notification) {
        if inputTextField.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if inputTextField.isFirstResponder {
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





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
    
    struct ChattingHistoryData {
        static let inputYSize: CGFloat = 50
    }
    
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
        let values = ["text": inputTextField.text!]
        ref.updateChildValues(values)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        addSubViews()
        setConstraints()
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
    
    
}





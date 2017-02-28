//
//  CommentNewViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 27..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class CommentNewViewController: UIViewController, UITextViewDelegate {
    
    var toUserId: String?
    var parentComment: String?
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "0 / 240자"
        label.textColor = .lightGray
        return label
    }()
    
    lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 260, height: 40))
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "댓글 쓰기"
        return label
    }()
    
    func commentDoneButtonTapped() {
        if let toUserId = self.toUserId, let myUid = FIRAuth.auth()?.currentUser?.uid {
            if let parentComment = self.parentComment {
                let ref = FirebaseDataService.instance.userRef.child(toUserId).child(Constants.Users.comments).child(parentComment).child(Constants.Comments.children).childByAutoId()
                ref.child(Constants.Comments.userId).setValue(myUid)
                ref.child(Constants.Comments.timestamp).setValue(NSNumber(value: Int(Date().timeIntervalSince1970)))
                ref.child(Constants.Comments.text).setValue(self.commentTextView.text)
                ref.child(Constants.Comments.parent).setValue(parentComment)
            } else {
                let ref = FirebaseDataService.instance.userRef.child(toUserId).child(Constants.Users.comments).childByAutoId()
                ref.child(Constants.Comments.userId).setValue(myUid)
                ref.child(Constants.Comments.timestamp).setValue(NSNumber(value: Int(Date().timeIntervalSince1970)))
                ref.child(Constants.Comments.text).setValue(self.commentTextView.text)
                ref.child(Constants.Comments.parent).setValue(ref.key)
            }
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon comment done"), style: .plain, target: self, action: #selector(commentDoneButtonTapped))
        
        addSubViews()
        setConstraints()
    }
    
    fileprivate func addSubViews() {
        view.addSubview(commentTextView)
        view.addSubview(countLabel)
    }
    
    fileprivate func setConstraints() {
        _ = commentTextView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = countLabel.anchor(view.topAnchor, left: nil, bottom: nil, right: commentTextView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 140, heightConstant: 20)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newText: NSString = textView.text! as NSString
        newText = newText.replacingCharacters(in: range, with: text) as NSString
        
        if newText.length > 240 {
            self.countLabel.textColor = UIColor.red
            self.commentTextView.text = newText.substring(to: 239)
        } else {
            self.countLabel.textColor = UIColor.darkGray
        }
        
        self.countLabel.text = "\(newText.length) / 240 자"
        return true
    }
}

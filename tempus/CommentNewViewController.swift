//
//  CommentNewViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 27..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class CommentNewViewController: UIViewController, UITextViewDelegate {
    
    var parentComment: String?
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        
        label.text = "0 / 240자"
        return label
    }()
    
    let commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.isScrollEnabled = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setConstraints()
    }
    
    fileprivate func addSubViews() {
        view.addSubview(commentTextView)
        view.addSubview(countLabel)
    }
    
    fileprivate func setConstraints() {
        _ = commentTextView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = countLabel.anchor(commentTextView.topAnchor, left: nil, bottom: nil, right: commentTextView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 140, heightConstant: 28)
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

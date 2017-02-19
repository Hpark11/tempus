//
//  CommunityViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class CommunityViewController: UIViewController {

    let cellId = "cellId"
    var controllerId: String?

    
    lazy var addStoryButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = UIColor.makeViaRgb(red: 248, green: 223, blue: 100)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(addStoryButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        button.titleLabel?.text = "개설 권한 얻기"
        button.setTitle("개설 권한 얻기", for: .normal)
        return button
    }()
    
    func observeFirebaseValue() {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            FirebaseDataService.instance.userRef.child(uid).child(Constants.Users.isGroupingAuth).observeSingleEvent(of: .value, with: { (snapshot) in
                if let flag = snapshot.value as? Bool {
                    if flag == true {
                        self.moveOnToNext()
                    }
                }
            })
        }
    }
    
    func moveOnToNext() {
        let communityMyListViewController = CommunityMyListViewController()
        navigationController?.pushViewController(communityMyListViewController, animated: true)
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon plus giver")
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 26))
        label.font = UIFont(name: "GothamRounded-Bold", size: 24)
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
        return label
    }()
    
    let signInLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "모임을 개설하고 싶으세요?"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    
    let subTextView: UITextView = {
        let subTextView = UITextView()
        subTextView.textAlignment = .center
        subTextView.isEditable = false
        subTextView.textAlignment = .center
        subTextView.backgroundColor = .clear
        subTextView.textColor = .lightGray
        subTextView.font = UIFont.systemFont(ofSize: 18)
        subTextView.text = "당신만의 이야기를 \n들려주세요"
        return subTextView
    }()
    
    let signInStartView: UIView = {
        let view = UIView()
        return view
    }()
    
    func addStoryButtonTapped() {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            let diaryViewController = DiaryViewController()
            present(diaryViewController, animated: true, completion: nil)
        } else {
            let signInViewController = SignInViewController()
            present(signInViewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setNavigationBarUI()
        addSubViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeFirebaseValue()
    }
    
    fileprivate func setNavigationBarUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        navigationItem.titleView = titleLabel
    }
    
    fileprivate func addSubViews() {
        
        view.addSubview(signInStartView)
        view.addSubview(imageView)
        view.addSubview(signInLabel)
        view.addSubview(subTextView)
        view.addSubview(addStoryButton)
    }
    
    fileprivate func setConstraints() {
        _ = imageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: view.frame.width / 3, bottomConstant: 0, rightConstant: view.frame.width / 3, widthConstant: 0, heightConstant: view.frame.height / 2)
        
        _ = signInLabel.anchor(imageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: -48, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 42)
        
        _ = subTextView.anchor(signInLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 48)
        
        _ = addStoryButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 64, rightConstant: 16, widthConstant: 0, heightConstant: 48)
    }

}

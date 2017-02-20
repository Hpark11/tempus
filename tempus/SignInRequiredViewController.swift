//
//  UserPageViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SignInRequiredViewController: UIViewController{

    let cellId = "cellId"
    var controllerId: String?
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = UIColor.makeViaRgb(red: 74, green: 144, blue: 226)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        button.titleLabel?.text = "로그인"
        button.setTitle("로그인", for: .normal)
        return button
    }()

    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon login")
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
        label.text = "로그인이 필요한 페이지"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    
    let subTextView: UITextView = {
        let subTextView = UITextView()
        subTextView.textAlignment = .center
        subTextView.isEditable = false
        subTextView.textAlignment = .center
        subTextView.textColor = .lightGray
        subTextView.font = UIFont.systemFont(ofSize: 18)
        subTextView.text = "로그인을 하시면 tempus의 \n다양한 혜택을 누리실 수 있습니다"
        return subTextView
    }()
    
    let signInStartView: UIView = {
        let view = UIView()
        return view
    }()
    
    func signInButtonTapped() {
        let signInViewController = SignInViewController()
        present(signInViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setNavigationBarUI()
        addSubViews()
        setConstraints()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = KeychainWrapper.standard.string(forKey: Constants.keychainUid) {
            
            if let controllerId = self.controllerId {
                if controllerId == Constants.ControllerId.userPage {
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .horizontal
                    layout.minimumLineSpacing = 0
                    layout.minimumInteritemSpacing = 0
                    let userPageViewController = UserPageViewController(collectionViewLayout: layout)
                    navigationController?.pushViewController(userPageViewController, animated: true)
                } else if controllerId == Constants.ControllerId.chatting {
                    let layout = UICollectionViewFlowLayout()
                    layout.scrollDirection = .horizontal
                    let chattingViewController = ChattingViewController()
                    navigationController?.pushViewController(chattingViewController, animated: true)
                }
            }
        }
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
        view.addSubview(signInButton)
    }
    
    fileprivate func setConstraints() {
        _ = imageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: view.frame.width / 3, bottomConstant: 0, rightConstant: view.frame.width / 3, widthConstant: 0, heightConstant: view.frame.height / 2)
        
        _ = signInLabel.anchor(imageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: -48, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 42)
        
        _ = subTextView.anchor(signInLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 48)
        
        _ = signInButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 64, rightConstant: 16, widthConstant: 0, heightConstant: 48)
    }
    
    

}

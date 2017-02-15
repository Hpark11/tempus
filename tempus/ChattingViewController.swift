//
//  ChattingViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ChattingViewController: UITableViewController {

    lazy var signOutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon signout"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 28)
        button.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(titleLabelTapped)))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    func titleLabelTapped() {
        let layout = UICollectionViewFlowLayout()
        let chattingHistoryViewController = ChattingHistoryViewController(collectionViewLayout: layout)
        navigationController?.pushViewController(chattingHistoryViewController, animated: true)
    }
    
    func signOutButtonTapped() {
        do {
            try FIRAuth.auth()?.signOut()
            KeychainWrapper.standard.removeObject(forKey: Constants.keychainUid)
            _ = navigationController?.popViewController(animated: true)
        } catch {
            let error = error as NSError
            print(":::[HPARK] Sign Out Failure \(error) :::\n")
        }
    }
    
    func handleNewMessage() {
        let chattingWithNewOneViewController = ChattingWithNewOneViewController()
        let navController = UINavigationController(rootViewController: chattingWithNewOneViewController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIsUserSignedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(signOutButtonTapped), with: nil, afterDelay: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        checkIsUserSignedIn()
        setNavigationBarUI()
    }

    fileprivate func setNavigationBarUI() {
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.tintColor = .white
        let signOutButtonItem = UIBarButtonItem(customView: signOutButton)
        self.navigationItem.leftBarButtonItem = signOutButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon add meeting"), style: .plain, target: self, action: #selector(handleNewMessage))
    }
    
    fileprivate func addSubViews() {

    }
    
    fileprivate func setConstraints() {

    }
}


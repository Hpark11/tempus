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

    let cellId = "cellId"
    var messages = [Message]()
    
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
        label.isUserInteractionEnabled = true
        return label
    }()
    
    func presentChattingHistory(user: Users) {
        let layout = UICollectionViewFlowLayout()
        let chattingHistoryViewController = ChattingHistoryViewController(collectionViewLayout: layout)
        chattingHistoryViewController.user = user
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
    
    func openChattingWithNewOne() {
        let chattingWithNewOneViewController = ChattingWithNewOneViewController()
        chattingWithNewOneViewController.attachedViewController = self
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
        observeMessages()
    }
    
    fileprivate func observeMessages() {
        FirebaseDataService.instance.messageRef.observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, AnyObject> {
                let message = Message()
                message.setValuesForKeys(dict)
                self.messages.append(message)
                
                DispatchQueue.main.async(execute: { 
                    self.tableView.reloadData()
                })
            }
        })
    }

    fileprivate func setNavigationBarUI() {
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.tintColor = .white
        let signOutButtonItem = UIBarButtonItem(customView: signOutButton)
        self.navigationItem.leftBarButtonItem = signOutButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon add meeting"), style: .plain, target: self, action: #selector(openChattingWithNewOne))
    }
    
    fileprivate func addSubViews() {

    }
    
    fileprivate func setConstraints() {

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.toUserId
        cell.detailTextLabel?.text = message.text
        
        return cell
    }
}


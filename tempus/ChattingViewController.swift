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
    var messagesDict = Dictionary<String, Message>()
    
    lazy var signOutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon signout"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 28)
        button.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 26))
        label.font = UIFont(name: "GothamRounded-Bold", size: 24)
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
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
        
        registerCells()
        
        messages.removeAll()
        messagesDict.removeAll()
        tableView.reloadData()
        observePreconfiguredUserMessage()
    }
    
    func observePreconfiguredUserMessage() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FirebaseDataService.instance.userMessageRef.child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let specificMessageRef = FirebaseDataService.instance.messageRef.child(messageId)
            
            specificMessageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? Dictionary<String, AnyObject> {
                    let message = Message()
                    message.setValuesForKeys(dict)
                    self.messages.append(message)
                    
                    if let toUserId = message.toUserId {
                        self.messagesDict[toUserId] = message
                        self.messages = Array(self.messagesDict.values)
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                        })
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
            })
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
    
    fileprivate func registerCells() {
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}


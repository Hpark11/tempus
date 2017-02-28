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
    var groups = [Group]()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 26))
        label.font = UIFont(name: "GothamRounded-Bold", size: 24)
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
        return label
    }()
    
    func presentChattingHistory(group: Group) {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: view.frame.width, height: 40)
        let chattingHistoryViewController = ChattingHistoryViewController(collectionViewLayout: layout)
        chattingHistoryViewController.group = group
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
        observePreconfiguredUserMessage()
        tableView.separatorColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func observePreconfiguredUserMessage() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        self.groups.removeAll()
        FirebaseDataService.instance.userRef.child(uid).child(Constants.Users.group).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Int> {
                for (key, _) in dict {
                    FirebaseDataService.instance.groupRef.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let dict = snapshot.value as? Dictionary<String, AnyObject> {
                            let group = Group(key: key, data: dict)
                            self.groups.append(group)
                        }
                        self.attemptReloadOfTable()
                    })
                }
            }
        })
    }
    
    private func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    func handleReloadTable() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    fileprivate func setNavigationBarUI() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon signout solid"), style: .plain, target: self, action: #selector(signOutButtonTapped))
        self.navigationItem.title = ""
    }
    
    fileprivate func registerCells() {
        tableView.register(GroupCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentChattingHistory(group: groups[indexPath.item])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GroupCell
        cell.group = groups[indexPath.item]
        cell.index = indexPath.item
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

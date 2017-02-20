//
//  CommunityMyListViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 20..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class CommunityMyListViewController: UITableViewController {

    let cellId = "cellId"
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 26))
        label.font = UIFont(name: "GothamRounded-Bold", size: 24)
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarUI()
        registerCells()
        tableView.backgroundColor = .black
    }

    
    fileprivate func setNavigationBarUI() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon signout solid"), style: .plain, target: self, action: #selector(signOutButtonTapped))
    }
    
    fileprivate func registerCells() {
        tableView.register(SelfMadeMeetingListCell.self, forCellReuseIdentifier: cellId)
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


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SelfMadeMeetingListCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

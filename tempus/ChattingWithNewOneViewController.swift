//
//  ChattingWithNewOneViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 16..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class ChattingWithNewOneViewController: UITableViewController {
    let cellId = "cellId"
    var users = [Users]()
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        registerCells()
        fetchAllFriends()
    }
    
    fileprivate func registerCells() {
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    func fetchAllFriends() {
        FirebaseDataService.instance.userRef.observe(.childAdded, with: { (snapshot) in
            if let value = snapshot.value as? Dictionary<String, AnyObject> {
                let user = Users(data: value)
                self.users.append(user)
                
                DispatchQueue.main.async(execute: { 
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.username
        cell.detailTextLabel?.text = user.email
        cell.profileImageView.imageUrlString = user.imageUrl
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}











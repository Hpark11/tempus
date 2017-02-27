//
//  CommentsViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 26..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class CommentsViewController: UITableViewController {
    
    let cellId = "cellId"
    
    var comments = [Comment]()
    var userInfo: Users? {
        didSet {
            if let comments = userInfo?.comments {
                for (key, data) in comments {
                    self.comments.append(data)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    fileprivate func registerCells() {
        tableView.register(CommentCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    
    
}

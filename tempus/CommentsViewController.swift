//
//  CommentsViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 26..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class CommentsViewController: UITableViewController {
    
    let cellId = "cellId"
    
    var comments = [Comment]()
    var userInfo: Users? {
        didSet {
            if let userId = userInfo?.uid {
                FirebaseDataService.instance.userRef.child(userId).child(Constants.Users.comments).observe(.value, with: { (snapshot) in
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        self.comments.removeAll()
                        for one in snapshot {
                            if let dict = one.value as? Dictionary<String, AnyObject> {
                                let comment = Comment(key: one.key, data: dict)
                                for (key, data) in comment.children {
                                    let comment = Comment(key: key, data: data as! Dictionary<String, AnyObject>)
                                    self.comments.append(comment)
                                }
                                self.comments.append(comment)
                            }
                        }
                    }
                    self.comments.reverse()
                    self.tableView?.reloadData()
                })
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 26))
        label.font = UIFont(name: "GothamRounded-Bold", size: 24)
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
        return label
    }()
    
    func openNewComment() {
        let commentNewViewController = CommentNewViewController()
        if let userId = self.userInfo?.uid {
            commentNewViewController.toUserId = userId
        }
        navigationController?.pushViewController(commentNewViewController, animated: true)
    }
    
    func cancelComment() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarUI()
        addSubViews()
        registerCells()
        view.backgroundColor = .white
        tableView.separatorColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadData()
    }
    
    fileprivate func setNavigationBarUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon submit"), style: .plain, target: self, action: #selector(openNewComment))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon cancel"), style: .plain, target: self, action: #selector(cancelComment))
        self.navigationItem.title = ""
    }
    
    fileprivate func addSubViews() {
        
    }
    
    fileprivate func setConstraints() {
        _ = tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func registerCells() {
        tableView.register(CommentCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commentNewViewController = CommentNewViewController()
        if let userId = self.userInfo?.uid {
            commentNewViewController.toUserId = userId
        }
        
        if let _ = self.comments[indexPath.item].parent {
            commentNewViewController.parentComment = self.comments[indexPath.item].parent
        } 
        navigationController?.pushViewController(commentNewViewController, animated: true)
        return
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

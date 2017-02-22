//
//  ShareFilesViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 22..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class ShareFilesViewController: UITableViewController {
    
    let cellId = "cellId"
    
    let dividerView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let dividerView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let sectionUploadView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let sectionDownloadView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    lazy var mainImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainPanelTapped)))
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = UIColor.makeViaRgb(red: 0, green: 159, blue: 232)
        return imageView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.font = UIFont.boldSystemFont(ofSize: 14)
        return textView
    }()
    
    lazy var uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.makeViaRgb(red: 74, green: 144, blue: 226)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        button.setTitle("유저정보 확인하기", for: .normal)
        return button
    }()
    
    let filenameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let filesizeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    func mainPanelTapped() {
        
    }
    
    func uploadButtonTapped() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setConstraints()
    }
    
    fileprivate func addSubViews() {
        view.addSubview(sectionUploadView)
        view.addSubview(mainImageView)
        view.addSubview(filenameLabel)
        view.addSubview(filesizeLabel)
        view.addSubview(uploadButton)
        view.addSubview(dividerView)
        view.addSubview(sectionDownloadView)
    }
    
    fileprivate func setConstraints() {
        _ = sectionUploadView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 44)
        
        _ = mainImageView.anchor(sectionUploadView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 128, heightConstant: 128)
        
        _ = filenameLabel.anchor(sectionUploadView.bottomAnchor, left: mainImageView.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 8, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 36)
        
        _ = filesizeLabel.anchor(filenameLabel.bottomAnchor, left: mainImageView.rightAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 240, heightConstant: 28)
        
        _ = uploadButton.anchor(nil, left: nil, bottom: mainImageView.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 160, heightConstant: 32)
        
        _ = dividerView.anchor(mainImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = sectionDownloadView.anchor(dividerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 44)
        
        _ = tableView.anchor(sectionDownloadView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func registerCells() {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}
